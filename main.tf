locals {
  ecs_cluster_name      = "ecs-cluster"
  ecs_cluster_full_name = "${var.environment}-${local.ecs_cluster_name}"
}

# EC2

data "aws_ssm_parameter" "ecs_node_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/arm64/recommended/image_id"
}

resource "aws_launch_template" "ec2" {
  name_prefix            = "${local.ecs_cluster_full_name}-"
  image_id               = data.aws_ssm_parameter.ecs_node_ami.value
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ecs_node_sg.id]

  iam_instance_profile { arn = aws_iam_instance_profile.ecs_node.arn }
  monitoring { enabled = true }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${module.ecs_cluster.name} >> /etc/ecs/ecs.config;
      echo ECS_IMAGE_PULL_BEHAVIOR=prefer-cached >> /etc/ecs/ecs.config;
    EOF
  )
}

resource "aws_autoscaling_group" "ec2" {
  name_prefix               = "${local.ecs_cluster_full_name}-asg-"
  vpc_zone_identifier       = var.subnets
  min_size                  = var.minimum_asg_size
  max_size                  = var.maximum_asg_size
  health_check_grace_period = 0
  health_check_type         = "EC2"
  protect_from_scale_in     = false

  launch_template {
    id      = aws_launch_template.ec2.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = local.ecs_cluster_full_name
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "ecs_node_sg" {
  name_prefix = "${local.ecs_cluster_full_name}-sg-"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_iam_policy_document" "ec2" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2" {
  name_prefix        = "${local.ecs_cluster_full_name}-role"
  assume_role_policy = data.aws_iam_policy_document.ec2.json
}

resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_node" {
  name_prefix = "${local.ecs_cluster_full_name}-profile"
  path        = "/ecs/instance/"
  role        = aws_iam_role.ec2.name
}

# ECS

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  environment = var.environment
  name        = local.ecs_cluster_name
}

module "ecs_cluster" {
  source  = "cloudposse/ecs-cluster/aws"
  version = "2.0.0"

  container_insights_mode    = var.container_insights_mode
  capacity_providers_fargate = false

  context = module.label.context
}

# This is used to enable more ENIs to exist on an instance.
resource "aws_ecs_account_setting_default" "vpcTrunking" {
  name  = "awsvpcTrunking"
  value = "enabled"
}

resource "aws_ecs_capacity_provider" "ecs" {
  name = local.ecs_cluster_full_name

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ec2.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs" {
  cluster_name       = local.ecs_cluster_full_name
  capacity_providers = [aws_ecs_capacity_provider.ecs.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs.name
    base              = 1
    weight            = 100
  }
}
module "subdomain" {
  source = "project-init/ec2-backed-ecs/aws"
  # Project Init recommends pinning every module to a specific version
  # version = "vX.X.X"

  environment = "staging"
  vpc_id      = "vpc-id"
  subnets     = ["subnet-1", "subnet-2"]

  instance_type    = "c7g.xlarge"
  minimum_asg_size = 1
  maximum_asg_size = 3
}
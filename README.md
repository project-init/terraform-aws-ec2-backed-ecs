# Project Init AWS EC2 Backed ECS

## Quick Start

1. `mise format`
2. `mise docs`

## Usage

Check our [Examples](examples) for full usage information.

## Useful Docs

* [Code of Conduct](./CODE_OF_CONDUCT.md)
* [Contribution Guide](./CONTRIBUTING.md)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.81.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.81.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | cloudposse/ecs-cluster/aws | v1.2.0 |
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_ecs_account_setting_default.vpcTrunking](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_account_setting_default) | resource |
| [aws_ecs_capacity_provider.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster_capacity_providers.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_iam_instance_profile.ecs_node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.ecs_node_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_iam_policy_document.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_ssm_parameter.ecs_node_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_insights_enabled"></a> [container\_insights\_enabled](#input\_container\_insights\_enabled) | Whether to enable container level insights. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment to produce the cluster in. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use for the instances in the cluster. | `string` | `"c7g.medium"` | no |
| <a name="input_maximum_asg_size"></a> [maximum\_asg\_size](#input\_maximum\_asg\_size) | The maximum number of ecs instances to have in the cluster. | `number` | `1` | no |
| <a name="input_minimum_asg_size"></a> [minimum\_asg\_size](#input\_minimum\_asg\_size) | The minimum number of ec2 instances to have in the cluster. | `number` | `1` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The subnets the cluster will go in to. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | The ARN of the ACM Certificate created for the Subdomain. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The id of the route53 zone created for the subdomain. |
<!-- END_TF_DOCS -->
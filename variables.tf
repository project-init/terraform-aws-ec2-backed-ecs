variable "environment" {
  type        = string
  description = "The name of the environment to produce the cluster in."
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID."
}

variable "subnets" {
  type        = list(string)
  description = "The subnets the cluster will go in to."
}

variable "instance_type" {
  type        = string
  default     = "c7g.medium"
  description = "The instance type to use for the instances in the cluster."
}

variable "minimum_asg_size" {
  type        = number
  default     = 1
  description = "The minimum number of ec2 instances to have in the cluster."
}

variable "maximum_asg_size" {
  type        = number
  default     = 1
  description = "The maximum number of ecs instances to have in the cluster."
}

variable "container_insights_mode" {
  type        = string
  default     = "disabled"
  description = "Level of container insights to have."

  validation {
    condition     = contains(["disabled", "enabled", "enhanced"], var.container_insights_mode)
    error_message = "container_insights_mode must be disabled, enabled, or enhanced."
  }
}
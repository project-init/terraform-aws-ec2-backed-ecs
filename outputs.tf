output "ecs_cluster_name" {
  value       = module.ecs_cluster.name
  description = "ECS cluster name"
}

output "ecs_cluster_arn" {
  value       = module.ecs_cluster.arn
  description = "ECS cluster ARN"
}

output "ecs_cluster_id" {
  value       = module.ecs_cluster.id
  description = "ECS cluster id"
}

output "ecs_cluster_role_name" {
  value       = module.ecs_cluster.role_name
  description = "IAM role name"
}

output "ecs_cluster_capacity_provider" {
  value       = aws_ecs_capacity_provider.ecs.name
  description = "Name of the Capacity Provider for the ECS Cluster."
}
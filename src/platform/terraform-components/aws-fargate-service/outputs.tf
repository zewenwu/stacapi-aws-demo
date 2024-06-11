output "task_role_id" {
  description = "ECS Task role ID"
  value       = aws_iam_role.task_role.id
}

output "task_role_arn" {
  description = "ECS Task role ARN"
  value       = aws_iam_role.task_role.arn
}

output "task_execution_role_id" {
  description = "ECS Task execution role ID"
  value       = aws_iam_role.task_execution.id
}

output "task_execution_role_arn" {
  description = "ECS Task execution role ARN"
  value       = aws_iam_role.task_execution.arn
}

output "service_security_group_id" {
  description = "ECS Service Security Group ID"
  value       = module.service_sg.security_group_id
}

output "secret_arn" {
  description = "ECS Service SecretsManager secret ARN"
  value       = aws_secretsmanager_secret.service_secret[0].arn
}

output "service_log_group_name" {
  description = "CloudWatch Log Group name for this service"
  value       = aws_cloudwatch_log_group.service.name
}

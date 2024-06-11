output "efs_file_system_id" {
  description = "EFS File System ID"
  value       = aws_efs_file_system.efs_file_system.id
}

output "efs_file_system_name" {
  description = "EFS File System Name"
  value       = aws_efs_file_system.efs_file_system.name
}

output "efs_file_system_arn" {
  description = "EFS File System ARN"
  value       = aws_efs_file_system.efs_file_system.arn
}

output "efs_file_system_security_group_id" {
  description = "EFS File System Security Group ID"
  value       = module.efs_sg.security_group_id
}

output "efs_kms_key_arn" {
  description = "EFS File System KMS Key ARN"
  value       = var.enable_kms_encryption ? module.efs_kms_key[0].key_arn : null
}

output "consumer_policy_id" {
  value       = aws_iam_policy.consumer.id
  description = "The ID of the IAM policy for the consumer."
}

output "consumer_policy_arn" {
  value       = aws_iam_policy.consumer.arn
  description = "The Amazon Resource Name (ARN) of the IAM policy for the consumer."
}
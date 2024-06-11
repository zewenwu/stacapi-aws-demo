### Notebook
output "notebook_instance_id" {
  description = "The ID of the SageMaker notebook instance"
  value       = aws_sagemaker_notebook_instance.notebook_instance.id
}

output "notebook_instance_arn" {
  description = "The ARN of the SageMaker notebook instance"
  value       = aws_sagemaker_notebook_instance.notebook_instance.arn
}

output "notebook_instance_url" {
  description = "The URL of the SageMaker notebook instance"
  value       = aws_sagemaker_notebook_instance.notebook_instance.url
}

### Notebook security group
output "notebook_security_group_id" {
  description = "The ID of the security group associated with the notebook"
  value       = module.notebook_sg.security_group_id
}

output "notebook_security_group_arn" {
  description = "The ARN of the security group associated with the notebook"
  value       = module.notebook_sg.security_group_arn
}

output "notebook_security_group_name" {
  description = "The name of the security group associated with the notebook"
  value       = module.notebook_sg.security_group_name
}

### Notebook bucket
output "notebook_bucket_id" {
  description = "The ID of the S3 bucket associated with the notebook"
  value       = module.notebook_bucket.bucket_id
}

output "notebook_bucket_arn" {
  description = "The ARN of the S3 bucket associated with the notebook"
  value       = module.notebook_bucket.bucket_arn
}

output "notebook_bucket_name" {
  description = "The name of the S3 bucket associated with the notebook"
  value       = module.notebook_bucket.bucket_name
}

### Notebook role
output "notebook_user_role_arn" {
  description = "The ARN of the IAM role associated with the notebook user"
  value       = aws_iam_role.notebook_role.arn
}

### Notebook kms key
output "notebook_kms_key_id" {
  description = "The ID of the KMS key used for the notebook"
  value       = module.notebook_kms_key.key_id
}

output "notebook_kms_key_arn" {
  description = "The ARN of the KMS key used for the notebook"
  value       = module.notebook_kms_key.key_arn
}

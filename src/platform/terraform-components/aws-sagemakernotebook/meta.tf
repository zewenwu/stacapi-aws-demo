data "aws_caller_identity" "main" {}

data "aws_region" "active" {}

locals {
  notebook_name        = "sagemaker-notebook-instance-${var.user_name}"
  notebook_role_name   = "sagemaker-notebook-instance-role-${var.user_name}"
  notebook_bucket_name = "sagemaker-notebook-bucket-${var.user_name}"
  notebook_key_name    = "sagemaker-notebook-key-${var.user_name}"
}

# AWS SageMaker Full Access Managed Policy
# data "aws_iam_policy" "sagemaker_full_access" {
#   name = "AmazonSageMakerFullAccess"
# }

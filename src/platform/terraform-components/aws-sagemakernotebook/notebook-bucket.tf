module "notebook_bucket" {
  source = "../aws-s3bucket"

  bucket_name                   = local.notebook_bucket_name
  append_random_suffix          = true
  force_s3_destroy              = false
  versioning_enabled            = true
  server_access_logging_enabled = false

  apply_bucket_policy                    = true
  enable_kms_encryption                  = true
  bucket_kms_allow_additional_principals = ["sagemaker.${data.aws_region.active.name}.amazonaws.com"]

  allowed_actions = [
    "s3:GetObject",
    "s3:PutObject",
    "s3:ListBucket"
  ]

  tags = var.tags
}

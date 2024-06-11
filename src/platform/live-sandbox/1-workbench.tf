module "sagemaker_notebook_tomhanks" {
  source = "../terraform-components/aws-sagemakernotebook"

  user_name = "tomhanks"

  notebook_instance_type = "ml.m5.xlarge"
  notebook_volume_size   = 50
  network_info = {
    vpc_id    = module.vpc.vpc_id
    subnet_id = module.vpc.private_subnets_ids.workbench[0]
  }

  notebook_policy_arns = {
    "data_bucket" = module.data_bucket.consumer_policy_arn
  }

  tags = local.tags
}

module "data_bucket" {
  source = "../terraform-components/aws-s3bucket"

  bucket_name                   = "data-bucket"
  append_random_suffix          = true
  force_s3_destroy              = true
  versioning_enabled            = true
  server_access_logging_enabled = false

  apply_bucket_policy                    = true
  enable_kms_encryption                  = true
  bucket_kms_allow_additional_principals = ["sagemaker.${data.aws_region.active.name}.amazonaws.com"]

  folder_names = ["0-test", "1-raw", "2-clean", "3-refined"]

  allowed_actions = [
    "s3:GetObject",
    "s3:PutObject",
    "s3:ListBucket"
  ]

}

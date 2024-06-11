data "aws_caller_identity" "active" {}

data "aws_region" "active" {}

locals {
  efs_name                 = "${var.efs_info.name}-efs"
  efs_name_short           = substr(var.efs_info.name, 0, 63) #64 character length
  efs_consumer_policy_name = "${var.efs_info.name}-efs-consumer-policy"
  efs_key_name             = "${var.efs_info.name}-efs-key"
}

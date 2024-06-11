### Service log group KMS Key
module "cloudwatch_log_group_kms_key" {
  count  = var.enable_kms_encryption_logs ? 1 : 0
  source = "../aws-kmskey"

  alias_name           = local.service_log_group_kms_key_name
  key_type             = "direct"
  append_random_suffix = true
  description          = "Used to encrypt cloudwatch logs: ${local.service_log_group_name}"
  tags                 = var.tags

  direct_key_principal = {
    Service = ["logs.${data.aws_region.active.name}.amazonaws.com"]
  }
}

### Service log group
resource "aws_cloudwatch_log_group" "service" {
  name              = local.service_log_group_name
  retention_in_days = var.logs_retention_days

  kms_key_id = var.enable_kms_encryption_logs ? module.cloudwatch_log_group_kms_key[0].key_id : null

  tags = merge({
    Name = local.service_log_group_name
  }, var.tags)
}

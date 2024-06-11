### EFS File System
resource "aws_efs_file_system" "efs_file_system" {
  creation_token   = local.efs_name_short
  encrypted        = true
  kms_key_id       = var.enable_kms_encryption ? module.efs_kms_key[0].key_arn : null
  performance_mode = "generalPurpose"

  throughput_mode                 = var.efs_info.throughput_mode
  provisioned_throughput_in_mibps = var.efs_info.throughput_mode == "provisioned" ? var.efs_info.provisioned_throughput_in_mibps : null

  tags = merge({
    Name = local.efs_name_short
  }, var.tags)
}

resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.efs_file_system.id

  backup_policy {
    status = var.backup_policy_status
  }
}

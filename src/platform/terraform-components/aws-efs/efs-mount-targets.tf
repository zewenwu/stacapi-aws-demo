### EFS Security Group
module "efs_sg" {
  source = "../aws-sg"

  service_name               = local.efs_name
  security_group_description = "Security group for EFS file system: ${var.efs_info.name}"
  vpc_id                     = var.network_info.vpc_id

  allow_additional_sg_ingress_ids = var.allow_additional_sg_ingress_ids
  additional_sg_port              = 2049 # NFS port
  additional_sg_protocol          = "tcp"

  tags = var.tags
}

### EFS Mount Targets
resource "aws_efs_mount_target" "efs_mount_target" {
  count           = length(var.network_info.subnet_ids)
  file_system_id  = aws_efs_file_system.efs_file_system.id
  subnet_id       = var.network_info.subnet_ids[count.index]
  security_groups = [module.efs_sg.security_group_id]
}

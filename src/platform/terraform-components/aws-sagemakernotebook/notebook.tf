### SageMaker Security Group
module "notebook_sg" {
  source = "../aws-sg"

  service_name               = local.notebook_name
  security_group_description = "Security group for SageMaker Notebook: ${local.notebook_name}"
  vpc_id                     = var.network_info.vpc_id

  allow_additional_sg_ingress_ids = []
  additional_sg_port              = 0
  additional_sg_protocol          = "-1"

  tags = var.tags
}

### SageMaker Notebook KMS Key
module "notebook_kms_key" {
  source = "../aws-kmskey"

  alias_name           = local.notebook_key_name
  key_type             = "service"
  append_random_suffix = true
  description          = "SageMaker Notebook encryption KMS key"
  tags                 = var.tags

  service_key_info = {
    caller_account_ids = [data.aws_caller_identity.main.account_id]
    aws_service_names  = ["sagemaker.${data.aws_region.active.name}.amazonaws.com"]
  }
}

### SageMaker Notebook Instance
resource "aws_sagemaker_notebook_instance" "notebook_instance" {
  name                = local.notebook_name
  instance_type       = var.notebook_instance_type
  platform_identifier = "notebook-al2-v1"
  role_arn            = aws_iam_role.notebook_role.arn

  root_access = "Enabled"
  volume_size = var.notebook_volume_size

  direct_internet_access = "Enabled"
  subnet_id              = var.network_info.subnet_id
  security_groups        = [module.notebook_sg.security_group_id]

  kms_key_id = module.notebook_kms_key.key_id

  tags = merge({
    Name = local.notebook_name
  }, var.tags)
}

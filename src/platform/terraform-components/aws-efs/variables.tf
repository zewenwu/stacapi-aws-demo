variable "efs_info" {
  description = <<EOH
The info block for the EFS File System.
The throughput_mode is either bursting, elastic, or provisioned.
If throughput_mode is provisioned, throughput_mibps must be set.
EOH
  type = object({
    name             = string
    throughput_mode  = string
    throughput_mibps = optional(number)
  })
  default = {
    name            = "test-efs"
    throughput_mode = "bursting"
  }
  validation {
    condition     = var.efs_info.throughput_mode != "provisioned" || (var.efs_info.throughput_mode == "provisioned" && var.efs_info.throughput_mibps != null)
    error_message = "If throughput_mode is provisioned, throughput_mibps must be set."
  }
}

### EFS Consumer Policy
variable "allowed_actions" {
  description = "List of EFS actions which are allowed for same account principals for the consumer policy"
  type        = list(string)
  default = [
    "elasticfilesystem:ClientMount",
    "elasticfilesystem:ClientWrite",
    "elasticfilesystem:ClientRootAccess",
  ]
}

### Network mount targets
variable "network_info" {
  description = "Network information for the EFS File System NFSv4 endpoint"
  type = object({
    vpc_id     = string
    subnet_ids = list(string)
  })
}

variable "allow_additional_sg_ingress_ids" {
  description = "Additional Security Group IDs to allow ingress traffic from"
  type        = list(string)
  default     = []
}

### EFS Backup Policy
variable "backup_policy_status" {
  description = "(optional) EFS Backup Policy Status"
  type        = string
  default     = "ENABLED"
}

### KMS Key
variable "enable_kms_encryption" {
  description = "Enable KMS Encryption for EFS"
  type        = bool
  default     = false
}

### Metadata
variable "tags" {
  description = "Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys"
  type        = map(string)
  default     = {}
}

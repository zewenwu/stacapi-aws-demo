variable "service_name" {
  description = "Name of the service"
  type        = string
}

variable "service_image" {
  description = "Image name for the container"
  type        = string
}

variable "service_count" {
  description = "Number of containers to deploy"
  type        = number
  default     = 1
}

variable "service_port" {
  description = "Port for the service to listen on"
  type        = number
}

variable "cpu" {
  description = "CPU (MHz) to dedicate to each deployed container. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html for valid value for Fargate tasks. For Eg: 512 "
  type        = string
}

variable "memory" {
  description = "Memory to dedicate to each deployed container. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html for valid value for Fargate tasks. For Eg: 512"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS Cluster name to deploy in"
  type        = string
}

variable "ecs_task_exec_role_policy_arns" {
  description = "Map of policies ARNs to attach to the ECS Execution Task Role. eg: { efs_policy = module.efs.consumer_policy_arn }"
  type        = map(string)
  default     = {}
}

variable "ecs_task_role_policy_arns" {
  description = "Map of policies ARNs to attach to the ECS Task Role. eg: { rds_policy = module.postgres_db.rds_policy_arn }"
  type        = map(string)
  default     = {}
}

variable "envvars" {
  description = "List of [{name = \"\", value = \"\"}] pairs of environment variables"
  type = set(object({
    name  = string
    value = string
  }))
  default = [{
    name  = "EXAMPLE_ENV"
    value = "example"
  }]
}

variable "secrets" {
  description = "Map of secret name(as reflected in Secrets Manager) and secret JSON string associated"
  type        = map(string)
  default     = {}
}

variable "optional_task_definition_attributes" {
  description = "[Optional] Other attributes to add to task definition"
  type        = string
  default     = "{}"
}

### Networking
variable "network_info" {
  description = "Network information for the ECS Service"
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

### Logs
variable "logs_retention_days" {
  description = "Number of days to retain logs in CloudWatch Logs"
  type        = number
  default     = 30
}

variable "enable_kms_encryption_logs" {
  description = "Enable KMS Encryption for CloudWatch Logs? (true/false)"
  type        = bool
  default     = false
}

### Application Load Balancer
variable "attach_lb" {
  description = "Attach the container to the public ALB? (true/false)"
  type        = bool
  default     = false
}

variable "lb_arn" {
  description = "The LB arn to attach to"
  type        = string
  default     = ""
}

variable "lb_type" {
  description = "The type of load balancer to create (application/network)"
  type        = string
  default     = "application"
}

variable "certificate_arn" {
  description = "Certitificate ARN to link with ALB"
  type        = string
  default     = ""
}

variable "alb_host_based_routing" {
  description = "[Optional] Mention host For ALB routing eg: some_host, specify one of host based or path based is needed for ALB listener when attach_alb is enable"
  type        = string
  default     = null
}

variable "alb_path_based_routing" {
  description = "Mention Path For ALB routing eg: / or /route1, specify one of host based or path based is needed for ALB listener when attach_alb is enable"
  type        = string
  default     = null
}

variable "alb_priority" {
  description = "Priority of ALB rule https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html#listener-rules"
  type        = string
  default     = "100"
}

variable "health_check" {
  description = "Health Check Config for the service"
  type        = map(string)

  default = {
    interval            = 30
    path                = ""
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200,201,204"
  }
}

variable "custom_header_token" {
  description = "Specify secret value for custom header that will be added to lb listener rules"

  type    = string
  default = null
}

### EFS Volumes
variable "efs_volume_ids" {
  description = "[Optional] EFS volume ids. Example format: { \"myEFSVolume\" = \"fs-1234\" }."
  type        = map(string)
  default     = {}
}

variable "efs_volume_mountpoints" {
  description = "[Optional] EFS volume container mount points. Example format: { \"myEFSVolume\" = \"/mount/efs\" }."
  type        = map(string)
  default     = {}
}

variable "efs_root_directory" {
  description = "[Optional] EFS root directory"
  type        = string
  default     = "/"
}

### Auto Scaling
variable "enable_auto_scaling" {
  description = "Enable auto scaling for the service"
  type        = bool
  default     = false
}

variable "auto_scale_config" {
  description = "Service scaling config"
  type = object({
    max_capacity        = number
    min_capacity        = number
    memory_target_value = number
    cpu_target_value    = number
  })
  default = null
}

variable "auto_scale_cooldown_config" {
  description = "Service scaling cooldown config. This is used in conjuction with auto scale config."
  type = object({
    scale_in  = number
    scale_out = number
  })
  default = {
    scale_in  = 300
    scale_out = 300
  }
}

### Metadata
variable "tags" {
  description = "Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys"
  type        = map(string)
  default     = {}
}

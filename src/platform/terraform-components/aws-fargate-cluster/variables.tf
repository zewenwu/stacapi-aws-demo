variable "cluster_name" {
  description = "Name of the ECS cluster to create"
  type        = string
}

variable "allowed_actions" {
  description = "List of ECS actions which are allowed for same account principals for the consumer policy"
  type        = list(string)
  default = [
    "ecs:DescribeTaskDefinition",
    "ecs:RegisterTaskDefinition",
    "ecs:UpdateService",
    "ecs:RunTask"
  ]
}

### Load Balancer
variable "create_lb" {
  description = "Create a load balancer for the cluster"
  type        = bool
  default     = false
}

variable "lb_listener_port" {
  description = "The port to listen on the ALB for public services (80/443, default 443)"
  type        = number
  default     = 443
}

variable "lb_type" {
  description = "The type of load balancer to create (application/network)"
  type        = string
}

variable "lb_access_logs_bucket" {
  description = "AWS ALB Access Logs Bucket"
  type        = string
  default     = ""
}

variable "internal_lb" {
  description = "(optional) Define whether to make internal or an internet-facing load balancer"
  type        = bool
  default     = true
}

### Networking
variable "network_info" {
  description = "Network information for the ECS Cluster"
  type = object({
    vpc_id     = string
    subnet_ids = list(string)
  })
}

variable "allow_additional_sg_load_balancer_ingress_ids" {
  description = "Additional Security Group IDs to allow ingress traffic to the cluster load balancer"
  type        = list(string)
  default     = []
}

### Tags
variable "tags" {
  description = "Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys"
  type        = map(string)
  default     = {}
}

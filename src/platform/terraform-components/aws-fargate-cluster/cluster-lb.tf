### Load Balancer Security Group
module "cluster_lb_sg" {
  count  = var.create_lb ? 1 : 0
  source = "../aws-sg"

  service_name               = local.cluster_lb_name
  security_group_description = "Security group for ECS Cluster Load Balancer: ${local.cluster_lb_name}"
  vpc_id                     = var.network_info.vpc_id

  allow_additional_sg_ingress_ids = var.allow_additional_sg_load_balancer_ingress_ids
  additional_sg_port              = var.lb_listener_port
  additional_sg_protocol          = "tcp"

  tags = var.tags
}

### Load Balancer
resource "aws_lb" "cluster_lb" {
  count                      = var.create_lb ? 1 : 0
  name                       = local.cluster_lb_name
  load_balancer_type         = var.lb_type
  subnets                    = var.network_info.subnet_ids
  security_groups            = [module.cluster_lb_sg[0].security_group_id]
  drop_invalid_header_fields = true
  enable_deletion_protection = false
  internal                   = var.internal_lb

  access_logs {
    bucket  = var.lb_access_logs_bucket
    prefix  = local.cluster_lb_name
    enabled = var.lb_access_logs_bucket == "" ? false : true
  }

  tags = merge({
    Name = local.cluster_lb_name
  }, var.tags)
}

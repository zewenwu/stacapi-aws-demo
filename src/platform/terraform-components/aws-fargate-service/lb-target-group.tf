### ECS Service Load Balancer Target Group
resource "aws_lb_target_group" "service" {
  count       = var.attach_lb ? 1 : 0
  name        = local.service_lb_tg_name_short
  port        = var.service_port
  protocol    = var.service_port == 443 ? "HTTPS" : (var.service_port == 80 || var.lb_type == "application" ? "HTTP" : "TCP")
  vpc_id      = var.network_info.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = var.health_check.interval
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
    protocol            = var.service_port == 443 ? "HTTPS" : (var.service_port == 80 || var.lb_type == "application" ? "HTTP" : "TCP")
    timeout             = var.service_port == 443 || var.service_port == 80 || var.lb_type == "application" ? var.health_check.timeout : null
    path                = var.service_port == 443 || var.service_port == 80 || var.lb_type == "application" ? var.health_check.path : null
    matcher             = var.service_port == 443 || var.service_port == 80 || var.lb_type == "application" ? var.health_check.matcher : null
  }

  tags = merge({
    Name = local.service_lb_tg_name_short
  }, var.tags)
}

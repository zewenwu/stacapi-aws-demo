### ECS Service Load Balancer Listener
resource "aws_lb_listener" "nlb_listener" {
  count             = var.attach_lb && var.lb_type == "network" ? 1 : 0
  load_balancer_arn = var.lb_arn

  port     = var.service_port
  protocol = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service[0].arn
  }
}

resource "aws_lb_listener" "alb_listener" {
  count             = var.attach_lb && var.lb_type == "application" ? 1 : 0
  load_balancer_arn = var.lb_arn

  port            = var.service_port
  protocol        = var.service_port == 443 ? "HTTPS" : "HTTP"
  certificate_arn = var.service_port == 443 ? var.certificate_arn : ""
  ssl_policy      = var.service_port == 443 ? "ELBSecurityPolicy-FS-1-2-Res-2019-08" : ""

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No service found"
      status_code  = "503"
    }
  }
}

resource "aws_lb_listener_rule" "alb_host_based_listener" {
  count        = var.attach_lb && var.alb_host_based_routing != null ? 1 : 0
  listener_arn = aws_lb_listener.alb_listener[0].arn
  priority     = var.alb_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service[0].arn
  }

  condition {
    host_header {
      values = [var.alb_host_based_routing == "" ? "*" : var.alb_host_based_routing]
    }
  }

  dynamic "condition" {
    for_each = var.custom_header_token == null ? [] : [true]
    content {
      http_header {
        http_header_name = "custom-header-token"
        values           = [var.custom_header_token]
      }
    }
  }
}

resource "aws_lb_listener_rule" "alb_path_based_listener" {
  count        = var.attach_lb && var.alb_path_based_routing != null ? 1 : 0
  listener_arn = aws_lb_listener.alb_listener[0].arn
  priority     = var.alb_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service[0].arn
  }

  condition {
    path_pattern {
      values = [var.alb_path_based_routing == "" ? "*" : var.alb_path_based_routing]
    }
  }

  dynamic "condition" {
    for_each = var.custom_header_token == null ? [] : [true]
    content {
      http_header {
        http_header_name = "custom-header-token"
        values           = [var.custom_header_token]
      }
    }
  }
}

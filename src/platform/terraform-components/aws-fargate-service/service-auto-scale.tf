resource "aws_appautoscaling_target" "ecs_target" {
  count = var.enable_auto_scaling ? 1 : 0

  max_capacity       = var.auto_scale_config.max_capacity
  min_capacity       = var.auto_scale_config.min_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_target_cpu" {
  count = var.enable_auto_scaling ? 1 : 0

  name               = "${var.service_name}-ecs-scaling-policy-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.auto_scale_config.cpu_target_value
    scale_in_cooldown  = var.auto_scale_cooldown_config.scale_in
    scale_out_cooldown = var.auto_scale_cooldown_config.scale_out
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}

resource "aws_appautoscaling_policy" "ecs_target_memory" {
  count = var.enable_auto_scaling ? 1 : 0

  name               = "${var.service_name}-ecs-scaling-policy-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = var.auto_scale_config.memory_target_value
    scale_in_cooldown  = var.auto_scale_cooldown_config.scale_in
    scale_out_cooldown = var.auto_scale_cooldown_config.scale_out
  }

  depends_on = [aws_appautoscaling_target.ecs_target]
}

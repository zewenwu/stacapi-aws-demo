### ECS Secrity Group
module "service_sg" {
  source = "../aws-sg"

  service_name               = local.service_name
  security_group_description = "Security group for ECS service: ${var.service_name}"
  vpc_id                     = var.network_info.vpc_id

  allow_additional_sg_ingress_ids = var.allow_additional_sg_ingress_ids
  additional_sg_port              = var.service_port
  additional_sg_protocol          = "tcp"

  tags = var.tags
}

### ECS Task Definition
resource "aws_ecs_task_definition" "service" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task_role.arn
  skip_destroy             = true

  container_definitions = jsonencode([
    merge(
      jsondecode(local.service_definition)[0],
      jsondecode(var.optional_task_definition_attributes)
    )
  ])

  dynamic "volume" {
    for_each = var.efs_volume_ids
    iterator = efs_volume_id
    content {
      name = efs_volume_id.key
      efs_volume_configuration {
        file_system_id     = efs_volume_id.value
        root_directory     = var.efs_root_directory
        transit_encryption = "ENABLED"
      }
    }
  }

  tags = merge({
    Name = var.service_name
  }, var.tags)
}

### ECS Service
resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = local.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = var.service_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [module.service_sg.security_group_id]
    subnets         = var.network_info.subnet_ids
  }

  dynamic "load_balancer" {
    for_each = var.attach_lb ? [true] : []
    content {
      target_group_arn = aws_lb_target_group.service[0].arn
      container_name   = var.service_name
      container_port   = var.service_port
    }
  }

  tags = merge({
    Name = var.service_name
  }, var.tags)
}

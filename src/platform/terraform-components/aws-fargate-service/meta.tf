data "aws_caller_identity" "active" {}

data "aws_region" "active" {}

# Append random string to SM Secret names because once we tear down the infra, the secret does not actually
# get deleted right away, which means that if we then try to recreate the infra, it'll fail as the
# secret name already exists.
resource "random_string" "service_secret_random_suffix" {
  length  = 5
  special = false
}

locals {
  service_name                   = "${var.service_name}-service"
  service_log_group_name         = "${var.service_name}-service-log-group"
  service_log_group_kms_key_name = "${var.service_name}-service-log-group-key"
  service_secret_name            = "${var.service_name}-service-secret-${random_string.service_secret_random_suffix.result}"

  service_lb_tg_name       = "${var.service_name}-lb-tg"
  service_lb_tg_name_short = substr(local.service_lb_tg_name, 0, min(32, length(local.service_lb_tg_name)))

  ecs_cluster_arn = "arn:aws:ecs:${data.aws_region.active.name}:${data.aws_caller_identity.active.account_id}:cluster/${var.ecs_cluster_name}"
}

locals {
  # Create secrets format for Task Definition 
  secret_keys = keys(var.secrets)
  secrets_task_definition = [for secret_key in local.secret_keys :
    tomap({
      "name"      = upper(secret_key),
      "valueFrom" = "${aws_secretsmanager_secret.service_secret[0].arn}:${secret_key}::"
      # See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/secrets-envvar-secrets-manager.html
    })
  ]

  # Create mountpoint format for Task Definition 
  mountpoints_task_definition = [for efs_name, mount_path in var.efs_volume_mountpoints :
    {
      sourceVolume  = efs_name
      containerPath = mount_path
      readOnly      = false
    }
  ]

  service_definition = templatefile("${path.module}/task-definitions/service-main-container.json", {
    cpu                         = var.cpu
    service_image               = var.service_image
    memory                      = var.memory
    log_group_name              = local.service_log_group_name
    region                      = data.aws_region.active.name
    service_name                = var.service_name
    service_port                = var.service_port
    envvars                     = jsonencode(var.envvars)
    secrets_task_definition     = jsonencode(local.secrets_task_definition)
    mountpoints_task_definition = jsonencode(local.mountpoints_task_definition)
  })

}


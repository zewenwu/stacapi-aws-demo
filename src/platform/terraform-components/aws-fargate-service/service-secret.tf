resource "aws_secretsmanager_secret" "service_secret" {
  count                   = signum(length(var.secrets))
  name                    = local.service_secret_name
  description             = "Secret for service: ${var.service_name}"
  kms_key_id              = null
  recovery_window_in_days = 30

  tags = merge({
    Name = local.service_secret_name
  }, var.tags)
}

resource "aws_secretsmanager_secret_version" "service_secret" {
  count         = signum(length(var.secrets))
  secret_id     = aws_secretsmanager_secret.service_secret[0].id
  secret_string = jsonencode(var.secrets)
}

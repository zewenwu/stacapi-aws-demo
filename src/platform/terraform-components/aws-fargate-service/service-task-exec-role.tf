resource "aws_iam_role" "task_execution" {
  name               = "${var.service_name}-ecs-task-execution"
  assume_role_policy = data.aws_iam_policy_document.task_execution_assume_role_policy.json

  tags = merge({
    Name = "${var.service_name}-task-execution"
  }, var.tags)
}

data "aws_iam_policy_document" "task_execution_assume_role_policy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

### Task Execution role policy
resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = aws_iam_role.task_execution.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

### Secrets
resource "aws_iam_policy" "service_get_secret" {
  count       = signum(length(var.secrets))
  name        = "${var.service_name}-service-secret-policy"
  description = "IAM policy to allow the service to pull the service secret from SecretsManager"

  policy = data.aws_iam_policy_document.service_get_secret[0].json
}

data "aws_iam_policy_document" "service_get_secret" {
  count   = signum(length(var.secrets))
  version = "2012-10-17"

  statement {
    sid     = "ServiceGetSecretValue"
    actions = ["secretsmanager:GetSecretValue"]
    effect  = "Allow"
    resources = [
      aws_secretsmanager_secret.service_secret[0].arn
    ]
  }
}

resource "aws_iam_role_policy_attachment" "service_get_secret" {
  count      = signum(length(var.secrets))
  role       = aws_iam_role.task_execution.name
  policy_arn = aws_iam_policy.service_get_secret[0].arn
}

### Additional policies
resource "aws_iam_role_policy_attachment" "task_execution_additional" {
  for_each   = var.ecs_task_exec_role_policy_arns
  role       = aws_iam_role.task_execution.id
  policy_arn = each.value
}

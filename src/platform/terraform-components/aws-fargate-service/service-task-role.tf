resource "aws_iam_role" "task_role" {
  name               = "${var.service_name}-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role_policy.json

  tags = merge({
    Name = "${var.service_name}-task"
  }, var.tags)
}

data "aws_iam_policy_document" "task_assume_role_policy" {
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

### Additional policies
resource "aws_iam_role_policy_attachment" "task_role_additional" {
  for_each   = var.ecs_task_role_policy_arns
  role       = aws_iam_role.task_role.id
  policy_arn = each.value
}

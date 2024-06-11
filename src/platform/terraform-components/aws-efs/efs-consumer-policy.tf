resource "aws_iam_policy" "consumer" {
  name   = local.efs_consumer_policy_name
  policy = data.aws_iam_policy_document.consumer.json
}

data "aws_iam_policy_document" "consumer" {

  dynamic "statement" {
    for_each = length(var.allowed_actions) > 0 ? [1] : []
    content {
      sid     = "AllowActionsOnEFS"
      effect  = "Allow"
      actions = var.allowed_actions
      resources = [
        aws_efs_file_system.efs_file_system.arn
      ]
    }
  }
}

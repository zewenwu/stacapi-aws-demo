
resource "aws_iam_policy" "consumer" {
  name   = local.cluster_consumer_policy_name
  policy = data.aws_iam_policy_document.consumer.json
}

data "aws_iam_policy_document" "consumer" {

  dynamic "statement" {
    for_each = length(var.allowed_actions) > 0 ? [1] : []
    content {
      sid     = "AllowActionsOnECSCluster"
      effect  = "Allow"
      actions = var.allowed_actions
      resources = [
        aws_ecs_cluster.cluster.arn
      ]
      condition {
        test     = "StringEquals"
        variable = "aws:PrincipalAccount"
        values   = [data.aws_caller_identity.current.account_id]
      }
    }
  }
}

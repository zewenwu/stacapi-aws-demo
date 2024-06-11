data "aws_caller_identity" "current" {}

locals {
  cluster_lb_name              = "${var.cluster_name}-lb"
  cluster_consumer_policy_name = "${var.cluster_name}-consumer-policy"
}

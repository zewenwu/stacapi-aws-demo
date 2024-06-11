output "ecs_cluster" {
  description = "ECS cluster details"
  value = {
    id   = aws_ecs_cluster.cluster.id
    name = aws_ecs_cluster.cluster.name
    arn  = aws_ecs_cluster.cluster.arn
  }
}

output "lb_details" {
  description = "Load Balancer details"
  value = var.create_lb ? {
    id                = aws_lb.cluster_lb[0].id
    name              = aws_lb.cluster_lb[0].name
    arn               = aws_lb.cluster_lb[0].arn,
    dns_name          = aws_lb.cluster_lb[0].dns_name,
    security_group_id = module.cluster_lb_sg[0].security_group_id
    type              = var.lb_type
  } : null
}

### Consumer policy
output "consumer_policy_arn" {
  value       = aws_iam_policy.consumer.arn
  description = "The ARN of the IAM policy for the consumer."
}

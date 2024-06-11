### Resources for STAC API
# ECR
module "stacapi_ecr" {
  source = "../terraform-components/aws-ecr"

  repository_name         = "stacapi"
  repository_force_delete = true

  pull_access_principal_arns = []
  push_access_principal_arns = []

  image_expiry_rule = {
    expire_type = "count"
    count       = 1
  }

  public_docker_image = "ghcr.io/stac-utils/stac-fastapi-pgstac:v2.4.10"
  is_immutable_image  = true
  tags                = local.tags
}

# ECS Cluster
module "stacapi_fargate_cluster" {
  source = "../terraform-components/aws-fargate-cluster"

  cluster_name = "stacapi"
  network_info = {
    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets_ids.workbench
  }

  create_lb             = true
  lb_listener_port      = 8080
  lb_type               = "application"
  lb_access_logs_bucket = ""
  internal_lb           = true

  allow_additional_sg_load_balancer_ingress_ids = [module.sagemaker_notebook_tomhanks.notebook_security_group_id]

  tags = local.tags
}

# ECS Service
module "stacapi_fargate_service" {
  source = "../terraform-components/aws-fargate-service"

  ecs_cluster_name = module.stacapi_fargate_cluster.ecs_cluster.name

  cpu           = "1024"
  memory        = "2048"
  service_count = 1

  service_image = module.stacapi_ecr.repository_url
  service_name  = "stacapi"
  service_port  = "8080"

  network_info = {
    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets_ids.workbench
  }
  allow_additional_sg_ingress_ids = [module.stacapi_fargate_cluster.lb_details.security_group_id]

  enable_auto_scaling = false
  auto_scale_config   = null

  attach_lb              = true
  lb_arn                 = module.stacapi_fargate_cluster.lb_details.arn
  lb_type                = module.stacapi_fargate_cluster.lb_details.type
  alb_path_based_routing = ""

  health_check = {
    interval            = 60
    timeout             = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
    path                = "/"
    matcher             = "200,201,204"
  }

  envvars = local.stacapi_service_envvars
  secrets = local.stacapi_service_secrets

  tags = local.tags
}

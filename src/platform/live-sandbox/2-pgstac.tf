### Resources for PgSTAC
# ECR
module "pgstac_ecr" {
  source = "../terraform-components/aws-ecr"

  repository_name         = "pgstac"
  repository_force_delete = true

  pull_access_principal_arns = []
  push_access_principal_arns = []

  image_expiry_rule = {
    expire_type = "count"
    count       = 1
  }

  public_docker_image = "ghcr.io/stac-utils/pgstac:v0.7.10"
  is_immutable_image  = true
  tags                = local.tags
}

# ECS Cluster
module "pgstac_fargate_cluster" {
  source = "../terraform-components/aws-fargate-cluster"

  cluster_name = "pgstac"
  network_info = {
    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets_ids.workbench
  }

  create_lb             = true
  lb_listener_port      = 5432
  lb_type               = "network"
  lb_access_logs_bucket = ""
  internal_lb           = true

  allow_additional_sg_load_balancer_ingress_ids = [module.stacapi_fargate_service.service_security_group_id]

  tags = local.tags
}

# ECS Service
module "pgstac_fargate_service" {
  source = "../terraform-components/aws-fargate-service"

  ecs_cluster_name = module.pgstac_fargate_cluster.ecs_cluster.name

  cpu           = "1024"
  memory        = "2048"
  service_count = 1
  service_image = module.pgstac_ecr.repository_url
  service_name  = "pgstac"
  service_port  = "5432"

  ecs_task_exec_role_policy_arns = {
    "pgstac_efs_policy" = module.pgstac_efs.consumer_policy_arn
  }

  network_info = {
    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets_ids.workbench
  }
  allow_additional_sg_ingress_ids = [module.pgstac_fargate_cluster.lb_details.security_group_id]

  enable_auto_scaling = false
  auto_scale_config   = null

  attach_lb = true
  lb_arn    = module.pgstac_fargate_cluster.lb_details.arn
  lb_type   = module.pgstac_fargate_cluster.lb_details.type

  health_check = {
    interval            = 60
    timeout             = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
    path                = "/"
    matcher             = "200,201,204"
  }

  efs_volume_ids = {
    "pgstacEFSVolume" = module.pgstac_efs.efs_file_system_id
  }

  efs_volume_mountpoints = {
    "pgstacEFSVolume" = "/var/lib/postgresql/data"
  }

  envvars = local.pgstac_service_envvars
  secrets = local.pgstac_service_secrets

  tags = local.tags
}

# EFS
module "pgstac_efs" {
  source = "../terraform-components/aws-efs"

  efs_info = {
    name            = "pgstac"
    throughput_mode = "bursting"
  }

  allowed_actions = [
    "elasticfilesystem:ClientMount",
    "elasticfilesystem:ClientWrite",
    "elasticfilesystem:ClientRootAccess",
  ]

  network_info = {
    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets_ids.workbench
  }
  allow_additional_sg_ingress_ids = [module.pgstac_fargate_service.service_security_group_id]

  backup_policy_status = "ENABLED"

  tags = local.tags
}

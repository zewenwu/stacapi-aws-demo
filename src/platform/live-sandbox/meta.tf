data "aws_region" "active" {}

resource "random_password" "postgres_pass" {
  length  = 16
  special = false
}

locals {
  postgres_user = "pguser"
  postgres_pass = random_password.postgres_pass.result
  postgres_db   = "postgis"

  postgres_host = module.pgstac_fargate_cluster.lb_details.dns_name
  postgres_port = "5432"

  tags = {
    Organisation = "DemoOrg"
    Department   = "GeoSpace"
    Environement = "Sandbox"
    Management   = "Terraform"
  }
}

locals {
  pgstac_service_envvars = [
    {
      name  = "POSTGRES_USER"
      value = local.postgres_user
    },
    {
      name  = "POSTGRES_DB"
      value = local.postgres_db
    },
    {
      name  = "PGUSER"
      value = local.postgres_user
    },
    {
      name  = "PGDATABASE"
      value = local.postgres_db
    },
  ]

  pgstac_service_secrets = {
    "POSTGRES_PASSWORD" = local.postgres_pass
    "PGPASSWORD"        = local.postgres_pass
  }

  stacapi_service_envvars = [
    {
      name  = "APP_HOST"
      value = "0.0.0.0"
    },
    {
      name  = "APP_PORT"
      value = "8082"
    },
    {
      name  = "RELOAD"
      value = "true"
    },
    {
      name  = "ENVIRONMENT"
      value = "local"
    },
    {
      name  = "POSTGRES_USER"
      value = local.postgres_user
    },
    {
      name  = "POSTGRES_DBNAME"
      value = local.postgres_db
    },
    {
      name  = "POSTGRES_HOST_READER"
      value = local.postgres_host
    },
    {
      name  = "POSTGRES_HOST_WRITER"
      value = local.postgres_host
    },
    {
      name  = "POSTGRES_PORT"
      value = local.postgres_port
    },
    {
      name  = "WEB_CONCURRENCY"
      value = "10"
    },
    {
      name  = "VSI_CACHE"
      value = "TRUE"
    },
    {
      name  = "GDAL_HTTP_MERGE_CONSECUTIVE_RANGES"
      value = "YES"
    },
    {
      name  = "GDAL_DISABLE_READDIR_ON_OPEN"
      value = "EMPTY_DIR"
    },
    {
      name  = "DB_MIN_CONN_SIZE"
      value = "1"
    },
    {
      name  = "DB_MAX_CONN_SIZE"
      value = "1"
    },
    {
      name  = "USE_API_HYDRATE"
      value = "false"
    },
  ]

  stacapi_service_secrets = {
    "POSTGRES_PASS" = local.postgres_pass
  }

}

aws_region = "us-east-2"
private_subnet_ids = [
  "subnet-0a1eeecd978b2d990",
  "subnet-06a1939485b03e1e8",
  "subnet-0227e2b0abc5f975e"
]
public_subnet_ids = [
  "subnet-026a7c8d08743d2f8",
  "subnet-0edb022b0a62fdf99",
  "subnet-09bd2427b14e632b8"
]
ecs_task_image_url        = "ghcr.io/appcd-dev/dogeapi/dogeapi:latest"
ecs_task_container_name   = "dogeapi"
ecs_task_container_cpu    = 256
ecs_task_container_memory = 512
ecs_task_container_port   = 8000
ecs_service_name          = "dogeapi"
ecs_cluster_name          = "appcd-demo-cluster"
ecs_task_environment_variables = {
  "ENVIRONMENT"                 = "dev",
  "TESTING"                     = "0",
  "DATABASE_URL"                = "sqlite:////var/run/dogeapi/dogeapi.sqlite",
  "SECRET_KEY"                  = "dev",
  "ACCESS_TOKEN_EXPIRE_MINUTES" = "30"
}
create_ingress_alb = true
internal_alb       = false
tags = {
  "Name"        = "dogeapi"
  "Region"      = "us-east-2"
  "Environment" = "dev"
}

# --- root/main.tf ---


module "networking" {
  source = "./modules/networking"

  subnet_availability_zone   = var.ZONE
  security_group_name        = "sg"
  security_group_description = "Allow django rest 8000 & nginx 80 ports"
}


module "ecr" {
  source = "./modules/ecr"

  api_repo      = var.api_repo
  frontend_repo = var.frontend_repo
}


module "iam" {
  source = "./modules/iam"

  codebuild_iam_role = "codebuild_iam_role"
}


module "lb" {
  source = "./modules/lb"

  depends_on = [
    module.networking
  ]

  vpc_id      = module.networking.vpc_id
  subnets_ids = module.networking.subnets_ids
  sg_id       = module.networking.sg_id
}


module "ecs" {
  source = "./modules/ecs"

  depends_on = [
    module.networking,
    module.iam,
    module.ecr,
    module.lb
  ]

  ecs_cluster_name     = "APICluster"
  task_definition_name = "task"
  ecs_service_name     = "svc"
  execution_role_arn   = module.iam.ecs_task_execution_role_arn
  task_role_arn        = module.iam.ecs_task_execution_role_arn
  vpc_id               = module.networking.vpc_id
  subnet_id            = module.networking.subnet_id
  sg_id                = module.networking.sg_id
  lb_target_group_arn  = module.lb.lb_target_group_arn
}


module "apiGateway" {
  source = "./modules/apiGateway"

  depends_on = [
    module.ecs
  ]

  API_GATEWAY_VPC_LINK_ID = module.ecs.svc_discovery_arn
  API_Name                = "Movies HTTP API"
  API_Protocol            = "HTTP"
  VPC_LINK_Name           = "moviesVPCLink"
  sg_id                   = module.networking.sg_id
  subnet_id               = module.networking.subnet_id
}


module "ci" {
  source = "./modules/ci"

  ci_pipeline_name                           = var.ci_pipeline_name
  ci_service_role                            = module.iam.codebuild_iam_role_arn
  ci_environment_privileged_mode             = true
  ci_build_timeout                           = "20"
  ci_queued_timeout                          = "30"
  ci_cache_type                              = "NO_CACHE"
  ci_artifacts_type                          = "NO_ARTIFACTS"
  ci_cloudwatch_logs_status                  = "ENABLED"
  ci_environment_type                        = "LINUX_CONTAINER"
  ci_environment_compute_type                = "BUILD_GENERAL1_SMALL"
  ci_environment_image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
  ci_environment_image_pull_credentials_type = "CODEBUILD"
  ci_source_location                         = var.ci_source_location
  ci_source_version                          = var.ci_source_version
  ci_source_report_build_status              = false
  ci_source_type                             = "GITHUB"

  # webhook

  ci_webhook_filter01_type    = "EVENT"
  ci_webhook_filter01_pattern = "PULL_REQUEST_MERGED"

  ci_webhook_filter02_type    = "BASE_REF"
  ci_webhook_filter02_pattern = var.ci_source_version
}
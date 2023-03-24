# TODO: Define baseline tags variable for deployment, and pass to each module
module "vpc_subnet_with_internet_access" {
  source = "./modules/vpc_subnet_with_internet_access"
}

module "ecs_fargate_task" {
  source = "./modules/ecs_fargate_task"

  region                           = var.region
  dragondrop_engine_container_path = var.dragondrop_engine_container_path
  task_cpu_count                   = var.task_cpu_count
  task_memory                      = var.task_memory

  depends_on = [module.vpc_subnet_with_internet_access]
}

module "containerized_lambda_https_endpoint" {
  source = "./modules/containerized_lambda_https_endpoint"

  dragondrop_api                          = var.dragondrop_api
  ecs_task_arn                            = module.ecs_fargate_task.ecs_task_arn
  https_trigger_containerized_lambda_name = var.https_trigger_containerized_lambda_name
  iam_policy_log_creator_arn              = module.ecs_fargate_task.log_creator_policy_arn
  lambda_role_assume_policy_json          = module.ecs_fargate_task.lambda_role_assume_policy_json
  lambda_ecr_container_uri                = var.lambda_ecr_container_uri
  security_group_id                       = module.vpc_subnet_with_internet_access.security_group
  subnet_id                               = module.vpc_subnet_with_internet_access.subnet

  depends_on = [module.vpc_subnet_with_internet_access, module.ecs_fargate_task]
}

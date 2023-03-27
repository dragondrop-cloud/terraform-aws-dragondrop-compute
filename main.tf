module "vpc_subnet_with_internet_access" {
  source = "./modules/vpc_subnet_with_internet_access"

  tags = var.tags
}

module "ecs_fargate_task" {
  source = "./modules/ecs_fargate_task"

  ecs_fargate_task_container_name  = var.ecs_fargate_task_container_name
  region                           = var.region
  dragondrop_engine_container_path = var.dragondrop_engine_container_path
  tags                             = var.tags
  task_cpu_count                   = var.task_cpu_count
  task_memory                      = var.task_memory

  depends_on = [module.vpc_subnet_with_internet_access]
}

module "lambda_https_endpoint" {
  source = "./modules/lambda_https_endpoint"

  dragondrop_api                            = var.dragondrop_api
  ecs_cluster_arn                           = module.ecs_fargate_task.ecs_cluster_arn
  ecs_fargate_task_container_name           = var.ecs_fargate_task_container_name
  ecs_task_arn                              = module.ecs_fargate_task.ecs_task_arn
  https_trigger_containerized_lambda_name   = var.https_trigger_containerized_lambda_name
  iam_policy_ecs_fargate_task_pass_role_arn = module.ecs_fargate_task.policy_pass_role_ecs_fargate_task_arn
  iam_policy_log_creator_arn                = module.ecs_fargate_task.log_creator_policy_arn
  lambda_role_assume_policy_json            = module.ecs_fargate_task.lambda_role_assume_policy_json
  lambda_s3_bucket_name                     = var.lambda_s3_bucket_name
  security_group_id                         = module.vpc_subnet_with_internet_access.security_group
  subnet_id                                 = module.vpc_subnet_with_internet_access.subnet
  tags                                      = var.tags

  depends_on = [module.vpc_subnet_with_internet_access, module.ecs_fargate_task]
}

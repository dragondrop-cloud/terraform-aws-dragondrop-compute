module vpc_subnet_with_internet_access {
  source = "./modules/vpc_subnet_with_internet_access"
}

module containerized_lambda_https_endpoint {
  source = "./modules/containerized_lambda_https_endpoint"
}

module ecs_fargate_task {
  source = "./modules/ecs_fargate_task"
}

// Defining Secrets and the IAM policies and roles needs
module "ecs_fargate_iam_secrets" {
  source = "../ecs_fargate_iam_secrets"

  dragondrop_api_path_name  = var.dragondrop_api_path
  log_creator_policy_name   = "log_creator"
  s3_state_bucket_name      = var.s3_state_bucket_name
  secret_reader_policy_name = "secret_reader"
  tags                      = var.tags
}

// ECS provisioning
resource "aws_ecs_cluster" "fargate_cluster" {
  name = "dragondrop-ecs-fargate-cluster"

  tags = merge(
    { origin = "dragondrop-compute-module" },
    var.tags,
  )
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.fargate_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

// ECS Fargate Task Definition
resource "aws_ecs_task_definition" "dragondrop_drift_task" {
  family                   = "dragondrop-drift-mitigation"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu_count
  memory                   = var.task_memory
  task_role_arn            = module.ecs_fargate_iam_secrets.role_ecs_fargate_task_arn
  execution_role_arn       = module.ecs_fargate_iam_secrets.role_ecs_fargate_task_arn

  // Bind mount host volumes only
  container_definitions = jsonencode([{
    name      = var.ecs_fargate_task_container_name
    image     = var.cloud_concierge_container_path
    cpu       = var.task_cpu_count
    memory    = var.task_memory
    essential = true

    secrets = [
      {
        name      = "CLOUDCONCIERGE_APIPATH"
        valueFrom = module.ecs_fargate_iam_secrets.api_path_secret_arn
      },
      {
        name      = "CLOUDCONCIERGE_VCSTOKEN"
        valueFrom = module.ecs_fargate_iam_secrets.vcs_token_secret_arn
      },
      {
        name      = "CLOUDCONCIERGE_TERRAFORMCLOUDTOKEN"
        valueFrom = module.ecs_fargate_iam_secrets.terraform_cloud_token_secret_arn
      },
    ],

    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group : "dragondrop-fargate-container",
        awslogs-region : var.region,
        awslogs-create-group : "true",
        awslogs-stream-prefix : "dragondrop"
      }
    }

    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
      }
    ]
  }])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = merge(
    { origin = "dragondrop-compute-module" },
    var.tags,
  )
}

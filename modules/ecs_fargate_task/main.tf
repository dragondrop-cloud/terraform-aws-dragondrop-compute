# Creating the ECS Cluster
resource "aws_cloudwatch_log_group" "ecs_fargate" {
  name              = "/aws/ecs/dragondrop-job-scan"
  retention_in_days = 7

  tags = {
    origin = "dragondrop-compute-module"
  }
}


resource "aws_ecs_cluster" "fargate_cluster" {
  name = "dragondrop-ecs-fargate-cluster"

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_fargate.name
      }
    }
  }

  tags = {
    origin = "dragondrop-compute-module"
  }
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

#resource "aws_ecs_service" {
# For a task on Fargate to pull a container image, the task must have a route to the internet.
# The following describes how you can verify that your task has a route to the internet.
# TODO: When using a public subnet, you can assign a public IP address to the task ENI.

# ECS Fargate Service
resource "aws_ecs_service" "dragondrop_drift_mitigation" {
  name            = "dragondrop_drift_mitigation"
  cluster         = aws_ecs_cluster.fargate_cluster.id
  task_definition = aws_ecs_task_definition.dragondrop_drift_task.arn
  desired_count   = 3
  launch_type     = "FARGATE"

  # TODO: Build out once an initial, baseline deployment of just the ECS task fully deploying.
  #  iam_role   = aws_iam_role.foo.arn
  #  depends_on = [aws_iam_role_policy.foo]

  network_configuration {
    subnets          = [var.subnet]
    security_groups  = [var.security_group]
    assign_public_ip = true
  }

  tags = {
    "origin" : "dragondrop-compute-module"
  }
}

// ECS Fargate Task Definition
resource "aws_ecs_task_definition" "dragondrop_drift_task" {
  family                   = "dragondrop-drift-mitigation"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu       = var.task_cpu_count
  memory    = var.task_memory

  // Bind mount host volumes only :check
  container_definitions = jsonencode([{
    name      = "dragondrop-driftmitigation-task"
    image     = var.dragondrop_engine_container_path
    cpu       = var.task_cpu_count
    memory    = var.task_memory
    essential = true

    environment = [
      {
        name  = "EXAMPLE_TEST"
        value = "TEST_VALUE"
      }
    ],

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

  tags = {
    "origin" : "dragondrop-compute-module"
  }
}

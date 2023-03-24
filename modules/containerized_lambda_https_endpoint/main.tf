# Forming the complete role for the lambda function to assume
resource "aws_iam_policy" "dragondrop_fargate_task_executor" {
  name   = "dragondrop-fargate-task-executor"
  path   = "/"
  policy = data.aws_iam_policy_document.ecs_task_executor.json

  tags = {
    origin = "dragondrop-compute-module"
  }

  depends_on = [data.aws_iam_policy_document.ecs_task_executor]
}

resource "aws_iam_role" "dragondrop_lambda_https_trigger" {
  assume_role_policy    = var.lambda_role_assume_policy_json
  description           = "Role assumed by the Lambda HTTPS trigger for dragondrop."
  force_detach_policies = false
  name                  = "dragondrop-fargate-runner"
  managed_policy_arns   = [var.iam_policy_log_creator_arn, aws_iam_policy.dragondrop_fargate_task_executor.arn]

  tags = {
    origin = "dragondrop-compute-module"
  }
}

# Creating the actual lambda function and the corresponding HTTPS endpoint.
resource "aws_lambda_function" "request_handler" {
  function_name = var.https_trigger_containerized_lambda_name
  description   = "Lambda that handles inbound HTTP trigger"

  role        = aws_iam_role.dragondrop_lambda_https_trigger.arn
  image_uri   = var.lambda_ecr_container_uri
  memory_size = 512

  environment {
    variables = {
      SUBNET          = var.subnet_id,
      SECURITY_GROUP  = var.security_group_id
      TASK_DEFINITION = var.ecs_task_arn
    }
  }

  vpc_config {
    security_group_ids = [var.security_group_id]
    subnet_ids         = [var.subnet_id]
  }

  tags = {
    origin = "dragondrop-compute-module"
  }
}

resource "aws_lambda_function_url" "dragondrop_https_endpoint" {
  function_name      = aws_lambda_function.request_handler.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = [var.dragondrop_api]
    allow_methods     = ["POST"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 60
  }
}

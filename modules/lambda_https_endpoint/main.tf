# Forming the complete role for the lambda function to assume
resource "aws_iam_policy" "dragondrop_fargate_task_executor" {
  name   = "dragondrop-fargate-task-executor"
  path   = "/"
  policy = data.aws_iam_policy_document.ecs_task_executor.json

  tags = merge(
    { origin = "dragondrop-compute-module" },
    var.tags,
  )

  depends_on = [data.aws_iam_policy_document.ecs_task_executor]
}

resource "aws_iam_role" "dragondrop_lambda_https_trigger" {
  assume_role_policy    = var.lambda_role_assume_policy_json
  description           = "Role assumed by the Lambda HTTPS trigger for dragondrop."
  force_detach_policies = false
  name                  = "dragondrop-lambda-https-trigger"
  managed_policy_arns = [
    var.iam_policy_log_creator_arn,
    var.iam_policy_ecs_fargate_task_pass_role_arn,
    aws_iam_policy.dragondrop_fargate_task_executor.arn
  ]

  tags = merge(
    { origin = "dragondrop-compute-module" },
    var.tags,
  )
}

# Creating the actual lambda function and the corresponding HTTPS endpoint.
resource "aws_lambda_function" "request_handler" {
  function_name = var.https_trigger_containerized_lambda_name
  description   = "Lambda that handles inbound HTTP trigger"

  role         = aws_iam_role.dragondrop_lambda_https_trigger.arn
  package_type = "Zip"
  s3_bucket    = var.lambda_s3_bucket_name
  s3_key       = "dragondrop_https_trigger_lambda.zip"
  handler      = "app.handler"
  runtime      = "python3.9"
  memory_size  = 512
  timeout      = 120

  environment {
    variables = {
      CONTAINER_NAME  = var.ecs_fargate_task_container_name
      ECS_CLUSTER_ARN = var.ecs_cluster_arn,
      SUBNET          = var.subnet_id,
      SECURITY_GROUP  = var.security_group_id
      TASK_DEFINITION = var.ecs_task_arn
    }
  }

  tags = merge(
    { origin = "dragondrop-compute-module" },
    var.tags,
  )
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

resource "aws_iam_role_policy_attachment" "aws_lambda_vpc_access_execution_role" {
  role       = aws_iam_role.dragondrop_lambda_https_trigger.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

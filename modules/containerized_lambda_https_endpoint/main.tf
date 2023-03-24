# Forming the complete role for the lambda function to assume


# Creating the actual lambda function and the corresponding HTTPS endpoint.
resource "aws_lambda_function" "request_handler" {
  function_name = var.https_trigger_containerized_lambda_name
  description   = "Lambda that handles inbound HTTP trigger"

  role        = "" # TODO: Lambda IAM Role needed here
  image_uri   = var.lambda_ecr_container_uri
  memory_size = 512

  #  environment = {} TODO: Is this needed at all?

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

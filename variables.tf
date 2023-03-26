# Variables with default values
variable "dragondrop_api" {
  description = "URL for the dragondrop API, used for controlling allowed origins on the Lambda URL."
  type        = string
  default     = "https://api.dragondrop.cloud"
}

variable "dragondrop_engine_container_path" {
  description = "Path to the dragondrop engine container used in the ECS Fargate job."
  type        = string
  default     = "us-east4-docker.pkg.dev/dragondrop-prod/dragondrop-engine/engine:latest"
}

variable "ecs_fargate_task_container_name" {
  description = "Name of the ecs fargate task container."
  type        = string
  default     = "dragondrop-driftmitigation-task"
}

variable "lambda_s3_bucket_name" {
  description = "Lambda public ECR container URI to reference."
  type        = string
  default     = "dragondrop-ecs-fargate-task-lambda-trigger-prod"
}


# Required variables for module
variable "https_trigger_containerized_lambda_name" {
  description = "Name of the https trigger containerized lambda that will trigger the dragondrop 'engine' hosted in an ECS Fargate task."
  type        = string
}

variable "region" {
  description = "AWS region into which resources will be deployed."
  type        = string
}

variable "service_account_name" {
  description = "Name of the service account with exclusively ECS Task invocation privileges that serves as the service account for compute created by the module."
  type        = string
}

variable "task_cpu_count" {
  description = "Number of vCPU units that the drift mitigation task should run on."
  type        = number
}

variable "task_memory" {
  description = "Amount of compute memory that the drift mitigation task should run on."
  type        = number
}

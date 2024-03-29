# Variables with default values that most users should not need/want to tweak.
variable "dragondrop_api" {
  description = "URL for the dragondrop API, used for controlling allowed origins on the Lambda URL."
  type        = string
  default     = "https://api.dragondrop.cloud"
}

variable "nlp_engine_api" {
  description = "URL for the NLP engine API, used for getting a recommended mapping between new resource and state file."
  type        = string
  default     = "https://us-east4-dragondrop-prod.cloudfunctions.net/nlpengine-endpoint-prod"
}

variable "cloud_concierge_container_path" {
  description = "Path to the cloud_concierge container used in the ECS Fargate job."
  type        = string
  default     = "docker.io/dragondropcloud/cloud-concierge:latest"
}

variable "ecs_fargate_task_container_name" {
  description = "Name of the ecs fargate task container."
  type        = string
  default     = "cloud-concierge-engine"
}

variable "lambda_s3_bucket_name" {
  description = "Lambda public ECR container URI to reference."
  type        = string
  default     = "dragondrop-ecs-fargate-task-lambda-trigger-prod"
}

variable "task_cpu_count" {
  description = "Number of vCPU units that the drift mitigation task should run on."
  type        = number
  default     = 4096
}

variable "task_memory" {
  description = "Amount of compute memory that the drift mitigation task should run on."
  type        = number
  default     = 8192
}

variable "s3_state_bucket_name" {
  description = "Optional name of the S3 bucket used for storing Terraform state. The ECS Fargate task created by the module will have read access to this bucket."
  type        = string
  default     = "NONE"
}

# Required variables for module
variable "https_trigger_lambda_name" {
  description = "Name of the https trigger lambda that will trigger the dragondrop 'engine' hosted in an ECS Fargate task."
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

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

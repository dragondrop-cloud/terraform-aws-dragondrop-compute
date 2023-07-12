variable "dragondrop_api_path" {
  description = "dragondrop API path."
  type        = string
}

variable "cloud_concierge_container_path" {
  description = "Path to the cloud_concierge container used in the cloud run job."
  type        = string
}

variable "ecs_fargate_task_container_name" {
  description = "Name of the ecs fargate task container."
  type        = string
}

variable "region" {
  description = "AWS region into which resources are to be deployed."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "task_cpu_count" {
  description = "Number of vCPU units that the drift mitigation task should run on."
  type        = number
}

variable "task_memory" {
  description = "Amount of compute memory that the drift mitigation task should run on."
  type        = number
}

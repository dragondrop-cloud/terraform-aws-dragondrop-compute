variable "dragondrop_engine_container_path" {
  description = "Path to the dragondrop engine container used in the cloud run job."
  type        = string
}

variable "security_group" {
  description = "Security group for ECS fargate task networking."
  type        = string
}

variable "subnet" {
  description = "Subnet within which the ECS Fargate Task is placed."
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

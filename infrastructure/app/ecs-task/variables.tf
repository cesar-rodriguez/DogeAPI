/* This file contains the variables used in the ECS task module */

## Global Input Variables
variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
}

## Core Infrastructure Input Variables

variable "aws_region" {
  type        = string
  description = "AWS Region to be used"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "A list of private subnet IDs"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "A list of public subnet IDs"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS Cluster"
}

## ECS Task Input Variables

variable "ecs_task_image_url" {
  type        = string
  description = "URL of the Docker image for the task"
}

variable "ecs_task_container_name" {
  type        = string
  description = "Name of the container in the task definition"
}

variable "ecs_task_container_cpu" {
  type        = number
  description = "The number of cpu units used by the ECS task"
  default     = 256
}

variable "ecs_task_container_memory" {
  type        = number
  description = "The amount (in MiB) of memory used by the ECS task"
  default     = 512
}

variable "ecs_task_container_port" {
  type        = number
  description = "The port exposed by the container"
  default     = 80
}

variable "ecs_task_environment_variables" {
  type        = map(string)
  description = "A map of environment variables to be passed to the container"
  default     = {}
}


## ECS Service Input Variables

variable "ecs_service_name" {
  type        = string
  description = "Name of the ECS service"
}

variable "ecs_service_desired_count" {
  type        = number
  description = "The number of instances of the task to run on the service"
  default     = 1
}

## Load Balancer Input Variables
variable "create_ingress_alb" {
  type        = bool
  description = "Whether to create an ALB with ingress to the ECS service"
  default     = true
}

variable "internal_alb" {
  type        = bool
  description = "Whether the ALB should be internal"
  default     = true
}

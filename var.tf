variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "ecs_log_group_name" {
  description = "Name of the CloudWatch Logs group for ECS"
  type        = string
  default     = "irs-consumer-test2-api"
}

variable "celery_log_group" {
  description = "Name of the CloudWatch Logs group for ECS celery"
  type        = string
  default     = "irs-consumer-backend-test2-celery-worker"
}


variable "log_group_admin" {
  description = "Name of the CloudWatch Logs group for ECS"
  type        = string
  default     = "irs-consumer-backend-test2-admin"
}

variable "ecs_log_driver_options" {
  description = "Options for the AWS Logs driver in ECS task"
  type        = map(string)
  default = {
    "awslogs-region"        = "us-east-1"
    "awslogs-group"         = "irs-consumer-test2-api"
    "awslogs-stream-prefix" = "ecs"
  }
}

variable "ecs_security_group_name" {
  description = "Name of the ECS Security Group"
  type        = string
  default     = "ecs-security-group"
}

variable "app_asg" {
  description = "Name of the ECS App Autoscaling Group"
  type        = string
  default     = "Infra-ECS-Cluster-IRS-Test2-App-ASG"
}

variable "admin_asg" {
  description = "Name of the ECS Admin Autoscaling Group"
  type        = string
  default     = "Infra-ECS-Cluster-IRS-Test2-Admin-ASG"
}

variable "api_capacity_provider" {
  description = "Name of the ECS App Capacity Provider"
  type        = string
  default     = "IRS_test2_capacity_provider_api"
}

variable "admin_capacity_provider" {
  description = "Name of the ECS Admin Capacity Provider"
  type        = string
  default     = "IRS_test2_capacity_provider_admin"
}

variable "lt_admin" {
  description = "Name of the ECS Admin Lauch Template"
  type        = string
  default     = "ECSLaunchTemplate-IRS-Test2-Admin"
}

variable "lt_app" {
  description = "Name of the ECS App Lauch Template"
  type        = string
  default     = "ECSLaunchTemplate-IRS-Test2-App"
}

variable "cluster_name" {
  description = "Name of the ECS Cluster Name"
  type        = string
  default     = "IRS-Test2"
}

variable "ecs_api_tg" {
  description = "Name of the ECS Api Target Group"
  type        = string
  default     = "irs-consumer-test2-api-tg"
}

variable "ecs_admin_tg" {
  description = "Name of the ECS Admin Target Group"
  type        = string
  default     = "irs-consumer-test2-admin-tg"
}

variable "ecs_alb" {
  description = "Name of the ECS Load Balancer"
  type        = string
  default     = "irs-test2-lb"
}


variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "db_name" {
  description = "Name of the Database"
  type        = string
  default     = "IRS-TEST2"
}

variable "allocated_storage" {
  description = "Allocated DB Storage"
  type        = number
  default     = 20
}

variable "engine" {
  description = "Name of the Database Engine"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Name of the Database Engine Version"
  type        = number
  default     = 15
}

variable "instance_class" {
  description = "Name of the Database Instance Class"
  type        = string
  default     = "db.t3.micro"
}

variable "parameter_group_name" {
  description = "Name of the Database Parameter Group"
  type        = string
  default     = "default.postgres15"
}

variable "final_snapshot_identifier" {
  description = "Name of the Database Snapshot Identifier"
  type        = string
  default     = "pgsql-snapshot"
}


variable "storage_type" {
  description = "Name of the Database Storage Type"
  type        = string
  default     = "gp2"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "s3" {
  type    = string
  default = "irsconsumerfrontendtest2"
}

variable "www_domain_name" {
  default = "test2-interpreterreservation.amnhealthcare.com"
}

variable "sch-s3" {
  type    = string
  default = "irsschedulerfrontendtest2"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1" # or whatever region you're using
}

variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "medusa-cluster"
}

variable "service_name" {
  default = "medusa-service"
}

variable "container_name" {
  default = "medusa-container"
}

variable "container_image" {
  default = "medusajs/medusa:latest"
}

variable "desired_count" {
  default = 1
}

variable "cpu" {
  default = 256
}

variable "memory" {
  default = 512
}

variable "port" {
  default = 9000
}

# New database variables
variable "db_name" {
  default = "medusa_db"
}

variable "db_username" {
  default = "medusauser"
}

variable "db_password" {
  description = "The password for the Medusa RDS PostgreSQL user"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  default = 20
}

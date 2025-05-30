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


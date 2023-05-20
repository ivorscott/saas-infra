variable "region" {
  description = "The AWS region."
  default = "eu-central-1"
  type = string
}

variable "hostname" {
  description = "The SaaS hostname."
  default = "example.com"
  type = string
}

variable "instance_type" {
  description = "The RDS instance type."
  type = string
}

variable "stage" {
  description = "The deployment stage."
  type = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type = string
}

variable "vpc_cidr_block" {
  description = "The VPC CIDR block"
  type = string
}

variable "database_subnet_group" {
  description = "The VPC database subnet group"
  type = string
}

variable "worker_node_security_group_id" {
  description = "The EKS Node security group id"
  type = string
}
variable "admin_email_address" {
  description = "The email address of the first admin user."
  type = string
}

variable "elb_url" {
  description = "The Elastic Load Balancer URL associated with the EKS cluster."
  type = string
}

variable "stage" {
  description = "The deployment stage."
  type = string
}
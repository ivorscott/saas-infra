variable "admin_email_address" {
  description = "The email address of the first admin user."
  type = string
}

variable "hostname" {
  description = "The SaaS hostname."
  default = "example.com"
  type = string
}

variable "stage" {
  description = "The deployment stage."
  type = string
}
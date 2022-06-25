variable "hostname" {
  description = "The SaaS hostname."
  default = "example.com"
  type = string
}

variable "stage" {
  description = "The deployment stage."
  type = string
}
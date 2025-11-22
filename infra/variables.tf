variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "alb_listener_port_1" {
  type    = number
  default = 80
}

variable "alb_listener_port_2" {
  type    = number
  default = 8000
}

variable "target_port" {
  type = number
  default = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = []
}
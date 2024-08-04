variable "aws_region" {
  description = "The AWS region to use"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "demo"
}

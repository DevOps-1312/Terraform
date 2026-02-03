# Variables
# environment variable
variable "Environment" {
  description = "The environment for the resources"
  type        = string
  default     = "dev"
}

# region variable
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

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

# instance count variable
variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 2
}

# monitoring variable
variable "enable_monitoring" {
  description = "Enable detailed monitoring for EC2 instances"
  type        = bool
  default     = true
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the EC2 instances"
  type        = bool
  default     = true
}
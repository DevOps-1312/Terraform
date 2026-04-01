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

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = list(string)
  default     = ["10.0.0.0/16", "192.168.0.0/8", "172.16.0.0/12"]
}

variable "allowed_vm_types" {
  description = "List of allowed EC2 instance types"
  type        = list(string)
  default     = ["t2.micro", "t2.small", "t2.medium"]
}

variable "allowed_regions" {
  description = "List of allowed AWS regions"
  type        = set(string)
  default     = ["us-east-1", "us-west-1", "eu-west-1", "eu-west-1"]
}
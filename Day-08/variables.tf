# Variables
# environment variable
variable "Environment" {
  description = "The environment for the resources"
  type        = string
  default     = "dev"
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
  type        = list(string)
  default     = ["us-east-1", "us-west-1", "eu-west-1", "eu-west-1"]
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {
    Environment = "dev1"
    name        = "dev_sample_instance"
    created_by  = "terraform"
  } 
}

variable "ingress_values" {
  type = tuple([ number, string, number ])
  default = [ 443, "tcp", 443 ]
}

variable "config" {
  type = object({
    region = string,
    monitoring = bool,
    instance_count = number
  })
  default = {
    region = "us-east-1",
    monitoring = true,
    instance_count = 1
  }
}

variable "bucket_names" {
  type = list(string)
  default = ["my-unique-bucket-day-07-name-12345", "my-unique-bucket-day-07-name-67890"]
}

variable "bucket_names_set" {
  type = set(string)
  default = ["my-unique-bucket-day-07-name-123450", "my-unique-bucket-day-07-name-678900"]
}
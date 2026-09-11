variable "project_name" {
  description = "The name of the project"
  default     = "Projet ALPHA Resource"
  type        = string
}

variable "default_tags" {
  description = "A map of default tags to apply to all resources"
  default     = {
    company = "Pavan's Tech Tutorials"
    manager = "Pavan"
  }
}

variable "environment_tags" {
  description = "A map of environment-specific tags"
  default     = {
    Environment = "Production"
    cost_center = "12345"
  }
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  default     = "Hello TechTutorial with Pavan1312"
  type        = string
}

variable "allowed_ports" {
  description = "A list of allowed ports for security group"
  default     = "22, 80, 443"
}

variable "instance_sizes" {
  description = "A list of instance sizes to be used"
  default     = {
    Dev  = "t2.micro"
    QA = "t2.small"
    UAT  = "t2.medium"
  }
}

variable "environment" {
  description = "The environment for which to create resources"
  default     = "UAT"
}
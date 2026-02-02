# Terraform configuration to create an S3 bucket, VPC, and EC2 instance with remote state management
# Using variables and locals for better resource naming

terraform {
    backend "s3" {
    bucket = "pavan-terraform-state-bucket-1312"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    use_lockfile = false
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Variables
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

# Locals
locals {
    bucket_name = "${var.Environment}-my-tf-test-pavan-bucket-1312-${var.aws_region}"
    vpc_name    = "${var.Environment}_vpc"
    EC2_name   = "${var.Environment}-EC2-instance"
}

# Create S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = local.bucket_name

  tags = {
    Name        = "${var.Environment}-Bucket"
    Environment = var.Environment
  }
}

# Create VPC
resource "aws_vpc" "sample_vpc" {
  cidr_block = "10.0.0.0/16"
  region = var.aws_region
    tags = {
        Environment = var.Environment
        Name = local.vpc_name
    }
}

# Create EC2 Instance
resource "aws_instance" "sample_instance" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t2.micro"
  region = var.aws_region
  tags = {
    Environment = var.Environment
    Name = local.EC2_name
  }
}

# Output variables
output "vpc_id" {
  value = aws_vpc.sample_vpc.id
}
output "s3_bucket_name" {
  value = local.bucket_name
}
output "ec2_instance_id" {
  value = aws_instance.sample_instance.id
}
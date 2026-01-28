# Terraform configuration to create an S3 bucket with remote state management

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

# Create S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-pavan-bucket-12345"

  tags = {
    Name        = "My bucket 2.0"
    Environment = "Dev"
  }
}
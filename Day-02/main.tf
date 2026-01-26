terraform {
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
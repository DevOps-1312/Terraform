# Terraform configuration to create an S3 bucket, VPC, and EC2 instance with remote state management
# Using variables and locals for better resource naming


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

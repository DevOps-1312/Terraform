# Example 1: create_before_destroy
# Use Case: EC2 instance that needs zero downtime during updates
# ==============================

resource "aws_instance" "lifecycle_instance" {
  ami = "ami-0ff8a91507f77f867" # Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type
  instance_type = var.allowed_vm_types[0] # Using the first allowed instance type from the list
  region = var.allowed_regions[0] # Using the first allowed region from the list
  monitoring = var.enable_monitoring

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# Example 2: prevent_destroy
# Use Case: Critical S3 bucket that should never be accidentally deleted
# ==============================

resource "aws_s3_bucket" "critical_data" {
  bucket = "my-critical-production-data-${var.Environment}-1312"

  tags = merge(var.tags, {
    Name       = "Critical Production Data Bucket"
    Demo       = "prevent_destroy"
    DataType   = "Critical"
    Compliance = "Required"
    }
  )
  # Lifecycle Rule: Prevent accidental deletion of this bucket
  # Terraform will throw an error if you try to destroy this resource
  # To delete: Comment out prevent_destroy first, then run terraform apply
  lifecycle {
    # prevent_destroy = true  # COMMENTED OUT TO ALLOW DESTRUCTION
  }
}

# Example 3: ignore_changes
# Use Case: Auto Scaling Group where capacity is managed externally
# ==============================

# Launch Template for Auto Scaling Group
resource "aws_launch_template" "app_server" {
  name_prefix   = "app-server"
  image_id      = "ami-0ff8a91507f77f867"
  instance_type = var.allowed_vm_types[0] # Using the first allowed instance type from the list

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "App Server from ASG"
        Demo = "ignore_changes"
      }
    )
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app_servers" {
  name               = "app-servers-asg"
  min_size           = 1
  max_size           = 5
  desired_capacity   = 2
  health_check_type  = "EC2"
  availability_zones = var.allowed_regions[0] == "us-east-1" ? ["us-east-1a", "us-east-1b"] : ["us-west-1a", "us-west-1b"]

  launch_template {
    id      = aws_launch_template.app_server.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "App Server ASG"
    propagate_at_launch = true
  }

  tag {
    key                 = "Demo"
    value               = "ignore_changes"
    propagate_at_launch = false
  }

  # Lifecycle Rule: Ignore changes to desired_capacity
  # This is useful when auto-scaling policies or external systems modify capacity
  # Terraform won't try to revert capacity changes made outside of Terraform
  lifecycle {
    ignore_changes = [
      desired_capacity,
      # Also ignore load_balancers if added later by other processes
    ]
  }
}


# Example 4: replace_triggered_by
# Use Case: Replace EC2 instances when security group changes
# ==============================

# Security Group
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Security group for application servers"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "App Security Group"
      Demo = "replace_triggered_by"
    }
  )
}

# EC2 Instance that gets replaced when security group changes
resource "aws_instance" "app_with_sg" {
  ami                    = "ami-0ff8a91507f77f867"
  instance_type          = var.allowed_vm_types[0] # Using the first allowed instance type from the list
  region                 = var.allowed_regions[0] # Using the first allowed region from the list
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = merge(
    var.tags,
    {
      Name = "App Instance with Security Group"
      Demo = "replace_triggered_by"
    }
  )

  # Lifecycle Rule: Replace instance when security group changes
  # This ensures the instance is recreated with new security rules
  lifecycle {
    replace_triggered_by = [
      aws_security_group.app_sg.id
    ]
  }
}

# Example 8: Combining Multiple Lifecycle Rules
# Use Case: DynamoDB table with comprehensive protections (SIMPLE EXAMPLE)
# ==============================

# This example shows how to combine multiple lifecycle rules on a single resource
# DynamoDB is used here because it's simple and doesn't require VPC setup

resource "aws_dynamodb_table" "critical_app_data" {
  name         = "${var.Environment}-app-data-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = merge(
    var.tags,
    {
      Name        = "Critical Application Data"
      Demo        = "multiple_lifecycle_rules"
      DataType    = "Critical"
      Environment = var.Environment
    }
  )

  # Multiple Lifecycle Rules Combined for Production Protection
  lifecycle {
    # Rule 1: Prevent accidental deletion
    # This protects the table from being destroyed accidentally
    # prevent_destroy = true  # COMMENTED OUT TO ALLOW DESTRUCTION

    # Rule 2: Create new resource before destroying old one
    # Ensures zero downtime if table needs to be recreated
    create_before_destroy = true

    # Rule 3: Ignore changes to certain attributes
    # Allow AWS to manage read/write capacity for auto-scaling
    ignore_changes = [
      # Ignore read/write capacity if using auto-scaling
      read_capacity,
      write_capacity,
    ]

    # Rule 4: Validate before creation
    precondition {
      condition     = contains(keys(var.tags), "Environment")
      error_message = "Critical table must have Environment tag for compliance!"
    }

    # Rule 5: Validate after creation
    postcondition {
      condition     = self.billing_mode == "PAY_PER_REQUEST" || self.billing_mode == "PROVISIONED"
      error_message = "Billing mode must be either PAY_PER_REQUEST or PROVISIONED!"
    }
  }
}
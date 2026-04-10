# Terraform configuration for EC2 instances with conditional expressions.
resource "aws_instance" "conditional_expression" {
  ami           = "ami-0ff8a91507f77f867"
  count = var.instance_count
  #instance_type = "t2.micro"
  instance_type = var.Environment == "dev" ? "t2.micro" : "t3.micro"

  tags = var.tags
}

# Create a security group with dynamic ingress rules
resource "aws_security_group" "ingress_rule" {
  name   = "sg"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      cidr_blocks = ingress.value.cidr_blocks
      protocol    = ingress.value.protocol
    }
  }
  egress  = []
}

# Splat expression to get all instance IDs
locals {
  all_instance_ids = aws_instance.conditional_expression[*].id
}

output "instances" {
  value = local.all_instance_ids
}
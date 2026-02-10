# AWS terraform type constraints

# Create EC2 Instance
resource "aws_instance" "sample_instance" {
  count = var.instance_count
  ami = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t2.micro"
  region = var.aws_region
  
  monitoring = var.enable_monitoring
  associate_public_ip_address = var.associate_public_ip

  tags = {
    Environment = var.Environment
    Name = local.EC2_name
  }
}

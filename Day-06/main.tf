# AWS terraform type constraints

# Create EC2 Instance
resource "aws_instance" "sample_instance" {
  count = var.instance_count
  ami = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = var.allowed_vm_types[0]  # using the first allowed instance type from the list
  #region = tolist(var.allowed_regions)[2] # using the third allowed region from the set (converted to list for indexing) 
  region = var.config.region               # using the region value from the config object variable (config.region)
  #monitoring = var.enable_monitoring      # using the monitoring value from the bool variable (enable_monitoring)
  monitoring = var.config.monitoring       # using the monitoring value from the config object variable (config.monitoring)
  associate_public_ip_address = var.associate_public_ip

  tags = var.tags
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_block[0] # using the first CIDR block from the list
  from_port         = var.ingress_values[0]
  ip_protocol       = var.ingress_values[1]
  to_port           = var.ingress_values[2]
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


locals {
  formatted_project_name = lower(replace(var.project_name, " ", "-"))
  New_tags = merge(var.default_tags, var.environment_tags)

  format_bucket_name = substr(lower(replace(var.bucket_name, " ", "-")), 0, 63)

  port_list = split(",", var.allowed_ports)
  sg_rules = [
    for port in local.port_list : 
    {
      name = "port-${port}"
      port = port
      description = "Allow traffic on port ${port}"
    }
  ]

  instance_sizes = lookup(var.instance_sizes, var.environment, "t2.micro")
}

resource "aws_s3_bucket" "first_S3_bucket" {
  bucket = local.format_bucket_name
  
  tags = local.New_tags
}
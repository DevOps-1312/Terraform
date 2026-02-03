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
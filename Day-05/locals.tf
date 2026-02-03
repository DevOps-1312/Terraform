# Locals
locals {
    bucket_name = "${var.Environment}-my-tf-test-pavan-bucket-1312-${var.aws_region}"
    vpc_name    = "${var.Environment}_vpc"
    EC2_name   = "${var.Environment}-EC2-instance"
}
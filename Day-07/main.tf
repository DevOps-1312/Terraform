resource "aws_s3_bucket" "my_bucket" {
  count = length(var.bucket_names)
  bucket = var.bucket_names[count.index]

  tags = var.tags
}

resource "aws_s3_bucket" "my_bucket_2" {
    for_each = var.bucket_names_set
    bucket = each.value
    
    tags = var.tags

    depends_on = [ aws_s3_bucket.my_bucket ]
}
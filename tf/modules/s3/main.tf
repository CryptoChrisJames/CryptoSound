resource "aws_s3_bucket" "ui_build_bucket" {
    bucket = "cryptosound/${var.env}/ui"
}

resource "aws_s3_bucket_acl" "ui_build_bucket_acl" {
    bucket = aws_s3_bucket.ui_build_bucket.id
    acl    = "private"
}
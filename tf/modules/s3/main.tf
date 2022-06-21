resource "aws_s3_bucket" "ui_build_bucket" {
    bucket = "cryptosound-ui-${var.env}"
}

resource "aws_s3_bucket_acl" "ui_build_bucket_acl" {
    bucket = aws_s3_bucket.ui_build_bucket.id
    acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "example" {
    bucket = aws_s3_bucket.ui_build_bucket.bucket

    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "error.html"
    }
}
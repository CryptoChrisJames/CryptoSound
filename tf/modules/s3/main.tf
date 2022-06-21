resource "aws_s3_bucket" "ui_build_bucket" {
    bucket = "cryptosound-ui-${var.env}"
}

resource "aws_s3_bucket_acl" "ui_build_bucket_acl" {
    bucket = aws_s3_bucket.ui_build_bucket.id
    acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "ui_web_hosting" {
    bucket = aws_s3_bucket.ui_build_bucket.bucket

    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "error.html"
    }
}

resource "aws_s3_bucket" "s3_bucket_ui_policy" {
    bucket = aws_s3_bucket.ui_build_bucket.id
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid":"PublicReadGetObject",
            "Effect":"Allow",
            "Principal": "*",
            "Action":["s3:GetObject"],
            "Resource":["arn:aws:s3:::cryptosound-ui-${var.env}/*"]
    }
  ]
}
EOF
}

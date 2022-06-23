terraform {
    backend "s3" {
        bucket = "crypto-sound-terraform"
        key = "cs-app-prod/cs-app-terraform-statefile-prod.tfstate"
        region = "us-east-1"
    }

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.19.0"
        }
        cloudflare = {
            source = "cloudflare/cloudflare"
            version = "~> 3.0"
        }
    }

    required_version = ">= 0.14.9"
}

provider "aws" {
    region  = "us-east-1"
    access_key = var.AWS_ID
    secret_key = var.AWS_SECRET
}

module "ecs" {
    source = "../../modules/ecs"

    env = var.env
    ecr_api_repo_url = var.ecr_api_repo_url
    current_api_image_tag = var.current_api_image_tag
}

module "s3" {
    source = "../../modules/s3"

    env = var.env
    bucket_name = "crypto-sound.com"
}

# Need to add an extra S3 bucket to redirect to our main site.
resource "aws_s3_bucket" "www_bucket" {
    bucket = "www.crypto-sound.com"
    acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "www_redirection" {
    bucket = aws_s3_bucket.www_bucket.bucket

    redirect_all_requests_to {
        host_name = "crypto-sound.com"
    }
}

resource "aws_s3_bucket_policy" "s3_bucket_ui_redirect_policy" {
    bucket = aws_s3_bucket.www_bucket.id
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid":"PublicReadGetObject",
            "Effect":"Allow",
            "Principal": "*",
            "Action":["s3:GetObject"],
            "Resource":["${aws_s3_bucket.www_bucket.arn}", "${aws_s3_bucket.www_bucket.arn}/*"]
    }
  ]
}
EOF
}
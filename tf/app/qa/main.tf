terraform {
    backend "s3" {
        bucket = "crypto-sound-terraform"
        key = "cs-app-qa/cs-app-terraform-statefile-qa.tfstate"
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
terraform {
    backend "s3" {
        bucket = "crypto-sound-terraform"
        key = "cs-app-qa/cs-app-terraform-statefile-qa.tfstate"
        region = "us-east-1"
    }

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.27"
        }
        cloudflare = {
            source = "cloudflare/cloudflare"
            version = "~> 3.0"
        }
    }

    required_version = ">= 0.14.9"
}

provider "aws" {
    profile = "default"
    region  = "us-east-1"
}

module "ecs" {
    source = "../../modules/ecs"

    env = var.env
    ecr_api_repo_url = var.ecr_api_repo_url
    current_api_image_tag = var.current_api_image_tag
}

module "dns" {
    source = "../../modules/dns"

    env = var.env
    cloudflare_key = var.cloudflare_key
    cloudflare_email = var.cloudflare_email
}
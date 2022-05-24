terraform {
    backend "s3" {
        bucket = "crypto-sound-terraform"
        key = "cs-app-terraform-statefile.tfstate"
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

provider "cloudflare" {
    email   = var.cloudflare_email
    api_key = var.cloudflare_key
}

resource "aws_ecs_cluster" "scp_cluster_qa" {
    name = "scp-cluster-qa"
}

resource "aws_ecs_cluster" "scp_cluster_stage" {
    name = "scp-cluster-stage"
}

resource "aws_ecs_cluster" "scp_cluster_prod" {
    name = "scp-cluster-prod"
}
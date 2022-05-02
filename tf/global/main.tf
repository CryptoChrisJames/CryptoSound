terraform {
    backend "s3" {
        bucket = "crypto-sound-terraform"
        key = "cs-terraform-statefile.tfstate"
        region = "us-east-1"
    }

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.27"
        }

        google = {
            source = "hashicorp/google"
            version = "4.19.0"
        }
    }

    required_version = ">= 0.14.9"
}

provider "aws" {
    profile = "default"
    region  = "us-east-1"
}

provider "google" {
    project = var.gcp_project
    region  = var.gcp_region
    zone    = var.gcp_zone
}

resource "aws_codebuild_project" "cs-pipeline-builder" {
    name          = "cs-pipeline-builder"
    description   = "CodeBuild project for building up the rest of the CICD pipeline"
    build_timeout = "5"
    service_role  = "arn:aws:iam::482352589093:role/service-role/codebuild-terraform-global-service-role"

    artifacts {
        type = "NO_ARTIFACTS"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"

        environment_variable {
            name = "GOOGLE_APPLICATION_CREDENTIALS"
            value = "https://crypto-sound-terraform.s3.amazonaws.com/credentials/cryptosound-349002-3c657660c8e2.json"
        }
    }

    source {
        type            = "GITHUB"
        location        = "https://github.com/StoryCollectorIO/CryptoSound.git"
        git_clone_depth = 1
        buildspec = "./buildspec/build-pipeline.yaml"
        git_submodules_config {
            fetch_submodules = true
        }
    }

    source_version = "main"
}

resource "aws_codebuild_source_credential" "cs-github-credentials" {
    auth_type   = "PERSONAL_ACCESS_TOKEN"
    server_type = "GITHUB"
    token       = var.github_token
}

resource "google_container_registry" "gcp_container_registry" {
    project  = var.gcp_project
    location = "US"
}
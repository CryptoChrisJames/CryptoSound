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
    }

    required_version = ">= 0.14.9"
}

provider "aws" {
    profile = "default"
    region  = "us-east-1"
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
        image                       = "aws/codebuild/standard:1.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"
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

    tags = {
        Environment = "qa"
    }
}

resource "aws_codebuild_source_credential" "cs-github-credentials" {
    auth_type   = "PERSONAL_ACCESS_TOKEN"
    server_type = "GITHUB"
    token       = var.github_token
}
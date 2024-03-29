terraform {
    backend "s3" {
        bucket = "crypto-sound-terraform"
        key = "cs-terraform-statefile.tfstate"
        region = "us-east-1"
    }

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.19.0"
        }
    }

    required_version = ">= 0.14.9"
}

provider "aws" {
    region  = "us-east-1"
    access_key = var.AWS_ID
    secret_key = var.AWS_SECRET
}

resource "aws_codebuild_project" "cs-pipeline-builder" {
    name          = "cs-pipeline-builder"
    description   = "CodeBuild project for building up the rest of the CICD pipeline"
    build_timeout = "5"
    service_role  = var.aws_cicd_role_arn

    artifacts {
        type = "NO_ARTIFACTS"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
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
}

resource "aws_codebuild_source_credential" "cs-github-credentials" {
    auth_type   = "PERSONAL_ACCESS_TOKEN"
    server_type = "GITHUB"
    token       = var.github_token
}

resource "aws_s3_bucket" "codepipeline_bucket" {
    bucket = "cs-pipeline-bucket"
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
    bucket = aws_s3_bucket.codepipeline_bucket.id
    acl    = "private"
}
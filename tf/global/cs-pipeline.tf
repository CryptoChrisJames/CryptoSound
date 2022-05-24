resource "aws_codepipeline" "cs_pipeline" {
    name = "cs-pipeline"
    role_arn = aws_iam_role.codepipeline_role.arn

    artifact_store {
        location = aws_s3_bucket.codepipeline_bucket.bucket
        type     = "S3"
    }

    stage {
        name = "Source"

        action {
            name             = "Source"
            category         = "Source"
            owner            = "ThirdParty"
            provider         = "GitHub"
            version          = "1"
            output_artifacts = ["code"]
            configuration = {
                OAuthToken           = var.github_token
                Owner                = var.repo_owner
                Repo                 = var.repo
                Branch               = var.branch
                PollForSourceChanges = var.poll_for_changes
            }
        }
    }

    stage {
        name = "Build"
            action {
                name             = "Build"
                category         = "Build"
                owner            = "AWS"
                provider         = "CodeBuild"
                input_artifacts  = ["code"]
                output_artifacts = ["qa_build"]
                version          = "1"

            configuration = {
                ProjectName = aws_codebuild_project.cs_build_qa.name
            }
        }
    }

    stage {
        name = "Deploy-QA"
            action {
                name             = "Deploy-QA"
                category         = "Build"
                owner            = "AWS"
                provider         = "CodeBuild"
                input_artifacts  = ["qa_build"]
                version          = "1"

            configuration = {
                ProjectName          = aws_codebuild_project.cs_deploy_qa.name
            }
        }
    }

    stage {
        name = "Approve-QA"
        action {
            name             = "Approve-QA"
            category         = "Approval"
            owner            = "AWS"
            provider         = "CodeBuild"
            version          = "1"
        }
    }

    stage {
        name = "Stage-Source"

        action {
            name             = "Stage-Source"
            category         = "Source"
            owner            = "ThirdParty"
            provider         = "GitHub"
            version          = "1"
            output_artifacts = ["stage_code"]
            configuration = {
                OAuthToken           = var.github_token
                Owner                = var.repo_owner
                Repo                 = var.repo
                Branch               = var.branch
                PollForSourceChanges = var.poll_for_changes
            }
        }
    }

    stage {
        name = "Stage-Build"
            action {
                name             = "Stage-Build"
                category         = "Build"
                owner            = "AWS"
                provider         = "CodeBuild"
                input_artifacts  = ["stage_code"]
                output_artifacts = ["stage_build"]
                version          = "1"

            configuration = {
                ProjectName = aws_codebuild_project.cs_build_stage.name
            }
        }
    }

    stage {
        name = "Deploy-Stage"
            action {
                name             = "Deploy-Stage"
                category         = "Build"
                owner            = "AWS"
                provider         = "CodeBuild"
                input_artifacts  = ["stage_build"]
                version          = "1"

            configuration = {
                ProjectName          = aws_codebuild_project.cs_deploy_stage.name
            }
        }
    }

    stage {
        name = "Approve-Stage"
        action {
            name             = "Approve-Stage"
            category         = "Approval"
            owner            = "AWS"
            provider         = "CodeBuild"
            version          = "1"
        }
    }

    stage {
        name = "Prod-Source"

        action {
            name             = "Prod-Source"
            category         = "Source"
            owner            = "ThirdParty"
            provider         = "GitHub"
            version          = "1"
            output_artifacts = ["prod_code"]
            configuration = {
                OAuthToken           = var.github_token
                Owner                = var.repo_owner
                Repo                 = var.repo
                Branch               = var.branch
                PollForSourceChanges = var.poll_for_changes
            }
        }
    }

    stage {
        name = "Prod-Build"
            action {
                name             = "Prod-Build"
                category         = "Build"
                owner            = "AWS"
                provider         = "CodeBuild"
                input_artifacts  = ["prod_code"]
                output_artifacts = ["prod_build"]
                version          = "1"

            configuration = {
                ProjectName = aws_codebuild_project.cs_build_prod.name
            }
        }
    }

    stage {
        name = "Deploy-Prod"
            action {
                name             = "Deploy-Prod"
                category         = "Build"
                owner            = "AWS"
                provider         = "CodeBuild"
                input_artifacts  = ["prod_build"]
                version          = "1"

            configuration = {
                ProjectName          = aws_codebuild_project.cs_deploy_prod.name
            }
        }
    }
}

resource "aws_iam_role" "codepipeline_role" {
    name = "codepipeline-assume-role"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "codepipeline.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
    name = "codepipeline_policy"
    role = aws_iam_role.codepipeline_role.id

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect":"Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketVersioning",
                "s3:PutObjectAcl",
                "s3:PutObject"
            ],
            "Resource": [
                "${aws_s3_bucket.codepipeline_bucket.arn}",
                "${aws_s3_bucket.codepipeline_bucket.arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_codebuild_project" "cs_build_qa" {
    name          = "cs-build-qa"
    description   = "CodeBuild project for building CryptoSound."
    build_timeout = "5"
    service_role  = "arn:aws:iam::482352589093:role/service-role/codebuild-terraform-global-service-role"

    artifacts {
        type = "CODEPIPELINE"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"

        privileged_mode = true

        environment_variable {
            name = "ENV"
            type = "PLAINTEXT"
            value = "qa"
        }

        environment_variable {
            name = "ECR_URL"
            type = "PLAINTEXT"
            value = aws_ecr_repository.cs_api_container_repo_qa.repository_url
        }

        environment_variable {
            name = "PORT"
            type = "PLAINTEXT"
            value = var.cs_api_port
        }
    }

    source {
        type      = "CODEPIPELINE"
        buildspec = "./buildspec/build.yaml"
    }

    source_version = "main"
}

resource "aws_codebuild_project" "cs_deploy_qa" {
    name          = "cs-deploy-qa"
    description   = "CodeBuild project for deploying CryptoSound."
    build_timeout = "5"
    service_role  = "arn:aws:iam::482352589093:role/service-role/codebuild-terraform-global-service-role"

    artifacts {
        type = "CODEPIPELINE"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"

        privileged_mode = true

        environment_variable {
            name = "ENV"
            type = "PLAINTEXT"
            value = "qa"
        }

        environment_variable {
            name = "ECR_URL"
            type = "PLAINTEXT"
            value = aws_ecr_repository.cs_api_container_repo_qa.repository_url
        }
    }

    source {
        type      = "CODEPIPELINE"
        buildspec = "./buildspec/deploy.yaml"
    }

    source_version = "main"
}

resource "aws_codebuild_project" "cs_build_stage" {
    name          = "cs-build-stage"
    description   = "CodeBuild project for building CryptoSound."
    build_timeout = "5"
    service_role  = "arn:aws:iam::482352589093:role/service-role/codebuild-terraform-global-service-role"

    artifacts {
        type = "CODEPIPELINE"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"

        privileged_mode = true

        environment_variable {
            name = "ENV"
            type = "PLAINTEXT"
            value = "stage"
        }

        environment_variable {
            name = "ECR_URL"
            type = "PLAINTEXT"
            value = aws_ecr_repository.cs_api_container_repo_stage.repository_url
        }

        environment_variable {
            name = "PORT"
            type = "PLAINTEXT"
            value = var.cs_api_port
        }
    }

    source {
        type      = "CODEPIPELINE"
        buildspec = "./buildspec/build.yaml"
    }

    source_version = "main"
}

resource "aws_codebuild_project" "cs_deploy_stage" {
    name          = "cs-deploy-stage"
    description   = "CodeBuild project for deploying CryptoSound."
    build_timeout = "5"
    service_role  = "arn:aws:iam::482352589093:role/service-role/codebuild-terraform-global-service-role"

    artifacts {
        type = "CODEPIPELINE"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"

        privileged_mode = true

        environment_variable {
            name = "ENV"
            type = "PLAINTEXT"
            value = "stage"
        }

        environment_variable {
            name = "ECR_URL"
            type = "PLAINTEXT"
            value = aws_ecr_repository.cs_api_container_repo_stage.repository_url
        }
    }

    source {
        type      = "CODEPIPELINE"
        buildspec = "./buildspec/deploy.yaml"
    }

    source_version = "main"
}

resource "aws_codebuild_project" "cs_build_prod" {
    name          = "cs-build-prod"
    description   = "CodeBuild project for building CryptoSound."
    build_timeout = "5"
    service_role  = "arn:aws:iam::482352589093:role/service-role/codebuild-terraform-global-service-role"

    artifacts {
        type = "CODEPIPELINE"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"

        privileged_mode = true

        environment_variable {
            name = "ENV"
            type = "PLAINTEXT"
            value = "prod"
        }

        environment_variable {
            name = "ECR_URL"
            type = "PLAINTEXT"
            value = aws_ecr_repository.cs_api_container_repo_prod.repository_url
        }

        environment_variable {
            name = "PORT"
            type = "PLAINTEXT"
            value = var.cs_api_port
        }
    }

    source {
        type      = "CODEPIPELINE"
        buildspec = "./buildspec/build.yaml"
    }

    source_version = "main"
}

resource "aws_codebuild_project" "cs_deploy_prod" {
    name          = "cs-deploy-prod"
    description   = "CodeBuild project for deploying CryptoSound."
    build_timeout = "5"
    service_role  = "arn:aws:iam::482352589093:role/service-role/codebuild-terraform-global-service-role"

    artifacts {
        type = "CODEPIPELINE"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"

        privileged_mode = true

        environment_variable {
            name = "ENV"
            type = "PLAINTEXT"
            value = "prod"
        }

        environment_variable {
            name = "ECR_URL"
            type = "PLAINTEXT"
            value = aws_ecr_repository.cs_api_container_repo_prod.repository_url
        }
    }

    source {
        type      = "CODEPIPELINE"
        buildspec = "./buildspec/deploy.yaml"
    }

    source_version = "main"
}
resource "aws_ecr_repository" "cs_api_container_repo_qa" {
    name                 = "cs-api-container-repo-qa"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }
}

resource "aws_ecr_repository" "cs_api_container_repo_stage" {
    name                 = "cs-api-container-repo-stage"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }
}

resource "aws_ecr_repository" "cs_api_container_repo_prod" {
    name                 = "cs-api-container-repo-prod"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }
}
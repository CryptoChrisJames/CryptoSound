resource "aws_codepipeline" "cs_pipeline_qa" {
    name = "cs-pipeline-qa"
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
                output_artifacts = ["build_output"]
                version          = "1"

            configuration = {
                ProjectName = aws_codebuild_project.cs_build_qa.name
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
    description   = "CodeBuild project for building CryptoSound UI"
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
            value = aws_ecr_repository.cs_ui_container_repo_qa.repository_url
        }
    }

    source {
        type      = "CODEPIPELINE"
        buildspec = "./buildspec/build.yaml"
    }

    source_version = "main"
}

resource "aws_ecr_repository" "cs_ui_container_repo_qa" {
    name                 = "cs-ui-container-repo-qa"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }
}
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

    # stage {
    #     name = "Deploy-QA"
    #         action {
    #             name             = "Deploy-QA"
    #             category         = "Build"
    #             owner            = "AWS"
    #             provider         = "CodeBuild"
    #             input_artifacts  = ["qa_build"]
    #             version          = "1"

    #         configuration = {
    #             ProjectName          = aws_codebuild_project.cs_deploy_qa.name
    #         }
    #     }
    # }

    stage {
        name = "Approve-QA"
        action {
            name             = "Approve-QA"
            category         = "Approval"
            owner            = "AWS"
            provider         = "Manual"
            version          = "1"
        }
    }

    stage {
        name = "Prod-Build"
            action {
                name             = "Prod-Build"
                category         = "Build"
                owner            = "AWS"
                provider         = "CodeBuild"
                input_artifacts  = ["code"]
                output_artifacts = ["prod_build"]
                version          = "1"

            configuration = {
                ProjectName = aws_codebuild_project.cs_build_prod.name
            }
        }
    }

    # stage {
    #     name = "Deploy-Prod"
    #         action {
    #             name             = "Deploy-Prod"
    #             category         = "Build"
    #             owner            = "AWS"
    #             provider         = "CodeBuild"
    #             input_artifacts  = ["prod_build"]
    #             version          = "1"

    #         configuration = {
    #             ProjectName          = aws_codebuild_project.cs_deploy_prod.name
    #         }
    #     }
    # }
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

        environment_variable {
            name = "NUXT_ENV_CONTENTFUL_TOKEN"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.qa_build_secret_version.secret_string)["NUXT_ENV_CONTENTFUL_TOKEN"]}"
        }

        environment_variable {
            name = "NUXT_ENV_ENVIRONMENT"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.qa_build_secret_version.secret_string)["NUXT_ENV_ENVIRONMENT"]}"
        }

        environment_variable {
            name = "NUXT_ENV_CONTENTFUL_SPACE"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.qa_build_secret_version.secret_string)["NUXT_ENV_CONTENTFUL_SPACE"]}"
        }

        environment_variable {
            name = "NUXT_ENV_CONTENTFUL_ENV"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.qa_build_secret_version.secret_string)["NUXT_ENV_CONTENTFUL_ENV"]}"
        }

        environment_variable {
            name = "NUXT_ENV_FIREBASE_API_KEY"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.qa_build_secret_version.secret_string)["NUXT_ENV_FIREBASE_API_KEY"]}"
        }

        environment_variable {
            name = "NUXT_ENV_FIREBASE_AUTH_DOMAIN"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.qa_build_secret_version.secret_string)["NUXT_ENV_FIREBASE_AUTH_DOMAIN"]}"
        }

        environment_variable {
            name = "NUXT_ENV_FIREBASE_PROJECT_ID"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.qa_build_secret_version.secret_string)["NUXT_ENV_FIREBASE_PROJECT_ID"]}"
        }

        environment_variable {
            name = "NUXT_ENV_FIREBASE_STORAGE_BUCKET"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.qa_build_secret_version.secret_string)["NUXT_ENV_FIREBASE_STORAGE_BUCKET"]}"
        }

        environment_variable {
            name = "NUXT_ENV_FIREBASE_MESSAGING_SENDER_ID"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.qa_build_secret_version.secret_string)["NUXT_ENV_FIREBASE_MESSAGING_SENDER_ID"]}"
        }

        environment_variable {
            name = "NUXT_ENV_FIREBASE_APP_ID"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.qa_build_secret_version.secret_string)["NUXT_ENV_FIREBASE_APP_ID"]}"
        }

        environment_variable {
            name = "NUXT_ENV_FIREBASE_MEASUREMENT_ID"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.qa_build_secret_version.secret_string)["NUXT_ENV_FIREBASE_MEASUREMENT_ID"]}"
        }
    }

    source {
        type      = "CODEPIPELINE"
        buildspec = "./buildspec/destroy.yaml"
    }

    source_version = "main"
}

# resource "aws_codebuild_project" "cs_deploy_qa" {
#     name          = "cs-deploy-qa"
#     description   = "CodeBuild project for deploying CryptoSound."
#     build_timeout = "5"
#     service_role  = "arn:aws:iam::482352589093:role/service-role/codebuild-terraform-global-service-role"

#     artifacts {
#         type = "CODEPIPELINE"
#     }

#     environment {
#         compute_type                = "BUILD_GENERAL1_SMALL"
#         image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
#         type                        = "LINUX_CONTAINER"
#         image_pull_credentials_type = "CODEBUILD"

#         privileged_mode = true

#         environment_variable {
#             name = "ENV"
#             type = "PLAINTEXT"
#             value = "qa"
#         }

#         environment_variable {
#             name = "ECR_URL"
#             type = "PLAINTEXT"
#             value = aws_ecr_repository.cs_api_container_repo_qa.repository_url
#         }
#     }

#     source {
#         type      = "CODEPIPELINE"
#         buildspec = "./buildspec/deploy.yaml"
#     }

#     source_version = "main"
# }

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

        environment_variable {
            name = "NUXT_ENV_CONTENTFUL_TOKEN"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.prod_build_secret_version.secret_string)["NUXT_ENV_CONTENTFUL_TOKEN"]}"
        }

        environment_variable {
            name = "NUXT_ENV_ENVIRONMENT"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.prod_build_secret_version.secret_string)["NUXT_ENV_ENVIRONMENT"]}"
        }

        environment_variable {
            name = "NUXT_ENV_CONTENTFUL_SPACE"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.prod_build_secret_version.secret_string)["NUXT_ENV_CONTENTFUL_SPACE"]}"
        }

        environment_variable {
            name = "NUXT_ENV_CONTENTFUL_ENV"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.prod_build_secret_version.secret_string)["NUXT_ENV_CONTENTFUL_ENV"]}"
        }

        environment_variable {
            name = "NUXT_ENV_FIREBASE_API_KEY"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.prod_build_secret_version.secret_string)["NUXT_ENV_FIREBASE_API_KEY"]}"
        }

        environment_variable {
            name = "NUXT_ENV_FIREBASE_AUTH_DOMAIN"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.prod_build_secret_version.secret_string)["NUXT_ENV_FIREBASE_AUTH_DOMAIN"]}"
        }

        environment_variable {
            name = "NUXT_ENV_FIREBASE_PROJECT_ID"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.prod_build_secret_version.secret_string)["NUXT_ENV_FIREBASE_PROJECT_ID"]}"
        }

        environment_variable {
            name = "NUXT_ENV_FIREBASE_STORAGE_BUCKET"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.prod_build_secret_version.secret_string)["NUXT_ENV_FIREBASE_STORAGE_BUCKET"]}"
        }

        environment_variable {
            name = "NUXT_ENV_FIREBASE_MESSAGING_SENDER_ID"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.prod_build_secret_version.secret_string)["NUXT_ENV_FIREBASE_MESSAGING_SENDER_ID"]}"
        }

        environment_variable {
            name = "NUXT_ENV_FIREBASE_APP_ID"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.prod_build_secret_version.secret_string)["NUXT_ENV_FIREBASE_APP_ID"]}"
        }

        environment_variable {
            name = "NUXT_ENV_FIREBASE_MEASUREMENT_ID"
            type = "PLAINTEXT"
            value = "${jsondecode(data.aws_secretsmanager_secret_version.prod_build_secret_version.secret_string)["NUXT_ENV_FIREBASE_MEASUREMENT_ID"]}"
        }
    }

    source {
        type      = "CODEPIPELINE"
        buildspec = "./buildspec/destroy.yaml"
    }

    source_version = "main"
}

# resource "aws_codebuild_project" "cs_deploy_prod" {
#     name          = "cs-deploy-prod"
#     description   = "CodeBuild project for deploying CryptoSound."
#     build_timeout = "5"
#     service_role  = "arn:aws:iam::482352589093:role/service-role/codebuild-terraform-global-service-role"

#     artifacts {
#         type = "CODEPIPELINE"
#     }

#     environment {
#         compute_type                = "BUILD_GENERAL1_SMALL"
#         image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
#         type                        = "LINUX_CONTAINER"
#         image_pull_credentials_type = "CODEBUILD"

#         privileged_mode = true

#         environment_variable {
#             name = "ENV"
#             type = "PLAINTEXT"
#             value = "prod"
#         }

#         environment_variable {
#             name = "ECR_URL"
#             type = "PLAINTEXT"
#             value = aws_ecr_repository.cs_api_container_repo_prod.repository_url
#         }
#     }

#     source {
#         type      = "CODEPIPELINE"
#         buildspec = "./buildspec/deploy.yaml"
#     }

#     source_version = "main"
# }
resource "aws_ecr_repository" "cs_api_container_repo_qa" {
    name                 = "cs-api-container-repo-qa"
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

data "aws_secretsmanager_secret" "qa_build_secret" {
    arn = "arn:aws:secretsmanager:us-east-1:482352589093:secret:qa-cs-config-bNTQ2q"
}

data "aws_secretsmanager_secret_version" "qa_build_secret_version" {
    secret_id = data.aws_secretsmanager_secret.qa_build_secret.id
}

data "aws_secretsmanager_secret" "prod_build_secrets" {
    arn = "arn:aws:secretsmanager:us-east-1:482352589093:secret:prod-cs-config-9QASbT"
}

data "aws_secretsmanager_secret_version" "prod_build_secret_version" {
    secret_id = data.aws_secretsmanager_secret.prod_build_secrets.id
}
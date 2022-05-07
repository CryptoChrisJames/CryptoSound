resource "aws_codebuild_project" "cs_build_ui" {
    name          = "cs-build-ui"
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
    }

    source {
        type            = "CODEPIPELINE"
        buildspec = "./buildspec/build.yaml"
    }

    source_version = "main"
}
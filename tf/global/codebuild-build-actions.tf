resource "aws_codebuild_project" "cs-build-ui" {
    name          = "cs-build-ui"
    description   = "CodeBuild project for building CryptoSound UI"
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

        environment_variable {
        name  = "SOME_KEY1"
        value = "SOME_VALUE1"
        }

        environment_variable {
        name  = "SOME_KEY2"
        value = "SOME_VALUE2"
        type  = "PARAMETER_STORE"
        }
    }

    source {
        type            = "GITHUB"
        location        = "https://github.com/mitchellh/packer.git"
        git_clone_depth = 1

        git_submodules_config {
            fetch_submodules = true
        }
    }

    source_version = "master"

    tags = {
        Environment = "qa"
    }
}
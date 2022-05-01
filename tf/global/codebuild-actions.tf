resource "aws_codebuild_project" "cs_build" {
    name          = "cs-build"
    description   = "CodeBuild project for building CryptoSound UI"
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

    }

    source {
        type            = "GITHUB"
        location        = "https://github.com/StoryCollectorIO/CryptoSound.git"
        git_clone_depth = 1
        buildspec = "./buildspec/build.yaml"

        git_submodules_config {
            fetch_submodules = true
        }
    }

    source_version = "main"
}
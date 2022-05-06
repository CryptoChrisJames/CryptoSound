resource "aws_codepipeline" "cs_pipeline_qa" {
    name = "cs-pipeline-qa"
    role_arn = var.aws_cicd_role_arn

    artifact_store {
        location = aws_s3_bucket.codepipeline_bucket.bucket
        type     = "S3"
    }

    stage {
        name = "Source"

        action {
            name             = "Source"
            category         = "Source"
            owner            = "AWS"
            provider         = "CodeStarSourceConnection"
            version          = "1"
            output_artifacts = ["source_output"]

            configuration = {
                ConnectionArn    = aws_codestarconnections_connection.codepipeline_connection.arn
                FullRepositoryId = var.repo
                BranchName       = var.branch
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
                input_artifacts  = ["source_output"]
                output_artifacts = ["build_output"]
                version          = "1"

            configuration = {
                ProjectName = aws_codebuild_project.cs_build_ui.name
            }
        }
    }
}
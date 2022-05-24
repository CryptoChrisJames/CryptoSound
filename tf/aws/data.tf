data "aws_iam_policy_document" "assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
        type        = "Service"
        identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

data "cloudflare_zones" "cs_domain" {
    filter {
        name = var.site_domain
    }
}

data "aws_ecr_image" "cs_api_image" {
    repository_name = "cs-api-container-repo-${var.env}"
}
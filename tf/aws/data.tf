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
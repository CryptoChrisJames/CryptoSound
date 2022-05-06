variable "github_token" {
    type = string
    description = "Github access token."
}

variable "aws_cicd_role_arn" {
    type = string
    description = "The arn connected to the aws role for teh ci-cd pipeline."
    default = "arn:aws:iam::482352589093:role/service-role/codebuild-terraform-global-service-role"
}
variable "repo_owner" {
    type        = string
    description = "Github CryptoSound repo owner"
}
variable "repo" {
    type        = string
    description = "Github CryptoSound repo."
}
variable "branch" {
    type        = string
    description = "Github CryptoSound repo branch"
}
variable "poll_for_changes" {
    type        = string
    description = "CodePipeline variable for polling for changes."
}
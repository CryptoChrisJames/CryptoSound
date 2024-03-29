variable "env" {
    type        = string
    description = "The current environment being deployed."
}

variable "ecr_api_repo_url" {
    type        = string
    description = "The URL that points to the current ecr repo."
}

variable "current_api_image_tag" {
    type        = string
    description = "The current image tag for cs api repo"
}

variable "app_name" {
    type        = string
    description = "CryptoSound app name."
    default     = "cryptosound"
}

variable "cloudflare_key" {
    type        = string
    description = "Cloudflare API key."
    default     = "cryptosound"
}

variable "cloudflare_email" {
    type        = string
    description = "Cloudflare email account."
}

variable "site_domain" {
    type        = string
    description = "The domain of the site. "
    default     = "crypto-sound.com"
}

variable "AWS_ID" {
    type        = string
    description = "AWS authentication ID."
}

variable "AWS_SECRET" {
    type        = string
    description = "AWS authentication secret."
}
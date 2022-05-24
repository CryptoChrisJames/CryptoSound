variable "env" {
    type        = string
    description = "The current environment being deployed."
}

variable "ecr_api_repo_url" {
    type        = string
    description = "The URL that points to the current "
}

variable "app_name" {
    type        = string
    description = "CryptoSound app name."
    default     = "cryptosound"
}

variable "cloudflare_key" {
    type        = string
    description = "Cloudflare API key"
    default     = "cryptosound"
}

variable "site_domain" {
    type        = string
    description = "The domain of the site. "
    default     = "crypto-sound.com"
}
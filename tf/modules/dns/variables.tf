variable "env" {
    type        = string
    description = "The current environment being deployed."
}

variable "app_name" {
    type        = string
    description = "CryptoSound app name."
    default     = "cryptosound"
}

variable "cloudflare_key" {
    type        = string
    description = "Cloudflare API key."
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

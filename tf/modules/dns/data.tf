data "cloudflare_zones" "cs_domain" {
    filter {
        name = var.site_domain
    }
}
resource "cloudflare_record" "cs_ui_cname" {
    zone_id = data.cloudflare_zones.cs_domain.zones[0].id
    name    = var.env
    value   = module.s3.ui_endpoint
    type    = "CNAME"

    ttl     = 1
    proxied = true
}

resource "cloudflare_record" "cs_api_cname" {
    zone_id = data.cloudflare_zones.cs_domain.zones[0].id
    name    = var.env == "prod" ? "api" : "${var.env}-api"
    value   = module.ecs.load_balancer_dns_name
    type    = "CNAME"

    ttl     = 1
    proxied = true
}

data "cloudflare_zones" "cs_domain" {
    filter {
        name = var.site_domain
    }
}
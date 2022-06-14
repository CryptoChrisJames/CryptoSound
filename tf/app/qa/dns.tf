# resource "cloudflare_record" "cs_prod_ui_cname" {
#     zone_id = data.cloudflare_zones.domain.zones[0].id
#     name    = var.site_domain
#     value   = aws_s3_bucket.site.website_endpoint
#     type    = "CNAME"

#     ttl     = 1
#     proxied = true
# }

# resource "cloudflare_record" "cs_prod_ui_www" {
#     zone_id = data.cloudflare_zones.domain.zones[0].id
#     name    = "www"
#     value   = var.site_domain
#     type    = "CNAME"

#     ttl     = 1
#     proxied = true
# }

resource "cloudflare_record" "cs_api_cname" {
    zone_id = data.cloudflare_zones.cs_domain.zones[0].id
    name    = var.env == "prod" ? "api" : "${var.env}-api"
    value   = module.ecs.load_balancer_dns_name
    type    = "CNAME"

    ttl     = 1
    proxied = true
}

resource "cloudflare_page_rule" "https" {
    zone_id = data.cloudflare_zones.cs_domain.zones[0].id
    target  = "*.${var.site_domain}/*"
    priority = 2
    lifecycle {
        ignore_changes = [priority]
    }
    actions {
        always_use_https = true
    }
}

data "cloudflare_zones" "cs_domain" {
    filter {
        name = var.site_domain
    }
}
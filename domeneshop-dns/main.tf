# https://registry.terraform.io/providers/innovationnorway/domeneshop/latest/docs

data "azurerm_public_ip" "pip" {
  name                = var.appgw_pip_name
  resource_group_name = var.resource_group_name
}

data "domeneshop_domains" "domain" {
  domain = var.domain
}

resource "domeneshop_record" "api" {
  domain_id = data.domeneshop_domains.domain.domains[0].id
  host      = "api"
  type      = "A"
  data      = data.azurerm_public_ip.pip.ip_address
  ttl       = 300
}

resource "domeneshop_record" "portal" {
  domain_id = data.domeneshop_domains.domain.domains[0].id
  host      = "portal"
  type      = "A"
  data      = data.azurerm_public_ip.pip.ip_address
  ttl       = 300
}

resource "domeneshop_record" "management" {
  domain_id = data.domeneshop_domains.domain.domains[0].id
  host      = "management"
  type      = "A"
  data      = data.azurerm_public_ip.pip.ip_address
  ttl       = 300
}
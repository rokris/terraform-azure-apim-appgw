data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = var.appgw_rg
}

resource "azurerm_user_assigned_identity" "base" {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  name                = var.user_assigned_identity_name
  tags                = var.tags
}

#Read the External Key Vault
data "azurerm_key_vault" "production_keyvault" {
  name                = var.keyvault
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id = data.azurerm_key_vault.production_keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.base.principal_id

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]

  certificate_permissions = [
    "Get",
  ]
}

resource "azurerm_subnet" "appgw" {
  name                 = var.appgw_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.appgw_subnet_iprange]
}

resource "azurerm_public_ip" "pip" {
  name                = var.appgw_pip_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

data "azurerm_public_ip" "pip" {
  name                = azurerm_public_ip.pip.name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "domeneshop_domains" "domain" {
  domain = var.domain
}

# Register in Public DNS server
resource "domeneshop_record" "api" {
  domain_id = data.domeneshop_domains.domain.domains[0].id
  host      = "api"
  type      = "A"
  data      = azurerm_public_ip.pip.ip_address
  ttl       = 300
}

resource "domeneshop_record" "portal" {
  domain_id = data.domeneshop_domains.domain.domains[0].id
  host      = "portal"
  type      = "A"
  data      = azurerm_public_ip.pip.ip_address
  ttl       = 300
}

resource "domeneshop_record" "management" {
  domain_id = data.domeneshop_domains.domain.domains[0].id
  host      = "management"
  type      = "A"
  data      = azurerm_public_ip.pip.ip_address
  ttl       = 300
}

# Read the External Key Vault
data "azurerm_key_vault" "example" {
  name                = var.keyvault
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_key_vault_certificate" "prod_certificate" {
  name         = var.certificate_name
  key_vault_id = data.azurerm_key_vault.production_keyvault.id
  depends_on   = [azurerm_key_vault_access_policy.policy]
}

data "azurerm_user_assigned_identity" "user" {
  name                = azurerm_user_assigned_identity.base.name
  resource_group_name = data.azurerm_resource_group.rg.name
  depends_on = [
    azurerm_user_assigned_identity.base
  ]
}

# Read Web Application Firewall policy ID
data "azurerm_web_application_firewall_policy" "waf-id" {
  name                = "ng-ti-test-rokris-waf"
  resource_group_name = var.appgw_rg
}

# Create an application gateway
resource "azurerm_application_gateway" "main" {
  name                = var.appgw_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location

  #  firewall_policy_id  = var.firewall_policy_id
  firewall_policy_id = data.azurerm_web_application_firewall_policy.waf-id.id
  enable_http2       = var.enable_http2
  tags               = var.tags

  identity {
    type = "UserAssigned"
    identity_ids = [
      data.azurerm_user_assigned_identity.user.id
    ]
  }

  sku {
    name     = var.sku
    tier     = var.sku
    capacity = 1
  }

  gateway_ip_configuration {
    name      = var.gateway_ip_config_name
    subnet_id = azurerm_subnet.appgw.id
  }

  frontend_port {
    name = var.frontend_port_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name  = var.backend_address_pool_name
    fqdns = [var.apim_gateway_dns_name, ]
  }

  backend_http_settings {
    name                  = var.https_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60
    probe_name            = var.probe_name
  }

  ssl_certificate {
    key_vault_secret_id = data.azurerm_key_vault_certificate.prod_certificate.versionless_secret_id
    name                = var.certificate_name
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = var.certificate_name
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101S"
  }

  probe {
    name                                      = var.probe_name
    host                                      = var.probe_apim_gateway_dns_name
    protocol                                  = "Https"
    interval                                  = 30
    minimum_servers                           = 0
    path                                      = "/status-0123456789abcdef"
    pick_host_name_from_backend_http_settings = false
    timeout                                   = 30
    unhealthy_threshold                       = 3
    match {
      status_code = [
        "200",
      ]
    }
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.https_setting_name
    priority                   = 1
  }
}
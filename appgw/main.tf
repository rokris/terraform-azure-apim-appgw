data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg"{
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

resource "azurerm_subnet" "frontend" {
  name                 = var.frontend_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.frontend_subnet_iprange]
}

resource "azurerm_subnet" "backend" {
  name                 = var.backend_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.backend_subnet_iprange]
}

resource "azurerm_public_ip" "pip" {
  name                = var.appgw_pip_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

#Read the External Key Vault
data "azurerm_key_vault" "example" {
  name                = var.keyvault
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_key_vault_certificate" "prod_certificate" {
  name                = var.certificate_name
  key_vault_id        = data.azurerm_key_vault.production_keyvault.id
}

data "azurerm_user_assigned_identity" "user" {
  name                = azurerm_user_assigned_identity.base.name
  resource_group_name = data.azurerm_resource_group.rg.name
  depends_on = [
    azurerm_user_assigned_identity.base
    ]
}

# Create an application gateway
resource "azurerm_application_gateway" "main" {
  name                = var.appgw_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location

  firewall_policy_id  = var.firewall_policy_id
  enable_http2        = var.enable_http2
  tags                = var.tags
  
  identity {
    type         = "UserAssigned"
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
    subnet_id = azurerm_subnet.frontend.id
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
    name         = var.backend_address_pool_name
    fqdns        = [var.apim_gateway_dns_name,]
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
    key_vault_secret_id = data.azurerm_key_vault_certificate.prod_certificate.secret_id
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
    policy_type = "Custom"
    cipher_suites = [
      "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256",
      "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
      "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384",
      "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384",
      "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
      "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256"
    ]
    min_protocol_version = "TLSv1_2"
  }

  probe {
    name                                      = var.probe_name
    host                                      = var.apim_gateway_dns_name
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

  # Security

  force_firewall_policy_association = var.force_firewall_policy_association

  dynamic "waf_configuration" {
    for_each = var.sku == var.sku && var.waf_configuration != null ? [var.waf_configuration] : []
    content {
      enabled                  = waf_configuration.value.enabled
      file_upload_limit_mb     = waf_configuration.value.file_upload_limit_mb
      firewall_mode            = waf_configuration.value.firewall_mode
      max_request_body_size_kb = waf_configuration.value.max_request_body_size_kb
      request_body_check       = waf_configuration.value.request_body_check
      rule_set_type            = waf_configuration.value.rule_set_type
      rule_set_version         = waf_configuration.value.rule_set_version

      dynamic "disabled_rule_group" {
        for_each = local.disabled_rule_group_settings != null ? local.disabled_rule_group_settings : []
        content {
          rule_group_name = disabled_rule_group.value.rule_group_name
          rules           = disabled_rule_group.value.rules
        }
      }

      dynamic "exclusion" {
        for_each = waf_configuration.value.exclusion != null ? waf_configuration.value.exclusion : []
        content {
          match_variable          = exclusion.value.match_variable
          selector                = exclusion.value.selector
          selector_match_operator = exclusion.value.selector_match_operator
        }
      }
    }
  }
}
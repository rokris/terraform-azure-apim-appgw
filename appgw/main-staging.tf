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

# Create the WAF policy
resource "azurerm_web_application_firewall_policy" "main" {
  location            = var.location
  name                = var.waf_policy_name
  resource_group_name = var.appgw_rg
  tags                = var.tags

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"

      rule_group_override {
        rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"

        rule {
          action  = "AnomalyScoring"
          enabled = false
          id      = "942100"
        }
        rule {
          action  = "AnomalyScoring"
          enabled = false
          id      = "942200"
        }
        rule {
          action  = "AnomalyScoring"
          enabled = false
          id      = "942110"
        }
        rule {
          action  = "AnomalyScoring"
          enabled = false
          id      = "942180"
        }
        rule {
          action  = "AnomalyScoring"
          enabled = false
          id      = "942260"
        }
        rule {
          action  = "AnomalyScoring"
          enabled = false
          id      = "942340"
        }
        rule {
          action  = "AnomalyScoring"
          enabled = false
          id      = "942370"
        }
        rule {
          action  = "AnomalyScoring"
          enabled = false
          id      = "942430"
        }
        rule {
          action  = "AnomalyScoring"
          enabled = false
          id      = "942440"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"

        rule {
          action  = "AnomalyScoring"
          enabled = false
          id      = "920300"
        }
        rule {
          action  = "AnomalyScoring"
          enabled = false
          id      = "920330"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"

        rule {
          action  = "AnomalyScoring"
          enabled = false
          id      = "931130"
        }
      }
    }
    managed_rule_set {
      type    = "Microsoft_BotManagerRuleSet"
      version = "1.0"
    }
  }

  policy_settings {
    enabled                          = true
    file_upload_limit_in_mb          = 100
    max_request_body_size_in_kb      = 128
    mode                             = "Prevention"
    request_body_check               = true
    request_body_inspect_limit_in_kb = 128
  }
}

## Read Web Application Firewall policy ID
#data "azurerm_web_application_firewall_policy" "waf-id" {
#  name                = "ng-ti-test-rokris-waf"
#  resource_group_name = var.appgw_rg
#}

# Create an application gateway
resource "azurerm_application_gateway" "main" {
  name                = var.appgw_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location

  #  firewall_policy_id  = var.firewall_policy_id
  firewall_policy_id = azurerm_web_application_firewall_policy.main.id
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
    name                           = var.https_setting_name
    cookie_based_affinity          = "Disabled"
    port                           = 443
    protocol                       = "Https"
    request_timeout                = 60
    probe_name                     = var.probe_name
    trusted_root_certificate_names = ["letsencrypt-stg-root-x1", ]
  }
  
  trusted_root_certificate {
    name = "letsencrypt-stg-root-x1"
    data = "-----BEGIN CERTIFICATE-----MIIFVDCCBDygAwIBAgIRAO1dW8lt+99NPs1qSY3Rs8cwDQYJKoZIhvcNAQELBQAwcTELMAkGA1UEBhMCVVMxMzAxBgNVBAoTKihTVEFHSU5HKSBJbnRlcm5ldCBTZWN1cml0eSBSZXNlYXJjaCBHcm91cDEtMCsGA1UEAxMkKFNUQUdJTkcpIERvY3RvcmVkIER1cmlhbiBSb290IENBIFgzMB4XDTIxMDEyMDE5MTQwM1oXDTI0MDkzMDE4MTQwM1owZjELMAkGA1UEBhMCVVMxMzAxBgNVBAoTKihTVEFHSU5HKSBJbnRlcm5ldCBTZWN1cml0eSBSZXNlYXJjaCBHcm91cDEiMCAGA1UEAxMZKFNUQUdJTkcpIFByZXRlbmQgUGVhciBYMTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALbagEdDTa1QgGBWSYkyMhscZXENOBaVRTMX1hceJENgsL0Ma49D3MilI4KS38mtkmdF6cPWnL++fgehT0FbRHZgjOEr8UAN4jH6omjrbTD++VZneTsMVaGamQmDdFl5g1gYaigkkmx8OiCO68a4QXg4wSyn6iDipKP8utsE+x1E28SA75HOYqpdrk4HGxuULvlr03wZGTIf/oRt2/c+dYmDoaJhge+GOrLAEQByO7+8+vzOwpNAPEx6LW+crEEZ7eBXih6VP19sTGy3yfqK5tPtTdXXCOQMKAp+gCj/VByhmIr+0iNDC540gtvV303WpcbwnkkLYC0Ft2cYUyHtkstOfRcRO+K2cZozoSwVPyB8/J9RpcRK3jgnX9lujfwA/pAbP0J2UPQFxmWFRQnFjaq6rkqbNEBgLy+kFL1NEsRbvFbKrRi5bYy2lNms2NJPZvdNQbT/2dBZKmJqxHkxCuOQFjhJQNeO+Njm1Z1iATS/3rts2yZlqXKsxQUzN6vNbD8KnXRMEeOXUYvbV4lqfCf8mS14WEbSiMy87GB5S9ucSV1XUrlTG5UGcMSZOBcEUpisRPEmQWUOTWIoDQ5FOia/GI+Ki523r2ruEmbmG37EBSBXdxIdndqrjy+QVAmCebyDx9eVEGOIpn26bW5LKerumJxa/CFBaKi4bRvmdJRLAgMBAAGjgfEwge4wDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFLXzZfL+sAqSH/s8ffNEoKxjJcMUMB8GA1UdIwQYMBaAFAhX2onHolN5DE/d4JCPdLriJ3NEMDgGCCsGAQUFBwEBBCwwKjAoBggrBgEFBQcwAoYcaHR0cDovL3N0Zy1kc3QzLmkubGVuY3Iub3JnLzAtBgNVHR8EJjAkMCKgIKAehhxodHRwOi8vc3RnLWRzdDMuYy5sZW5jci5vcmcvMCIGA1UdIAQbMBkwCAYGZ4EMAQIBMA0GCysGAQQBgt8TAQEBMA0GCSqGSIb3DQEBCwUAA4IBAQB7tR8B0eIQSS6MhP5kuvGth+dN02DsIhr0yJtk2ehIcPIqSxRRmHGl4u2c3QlvEpeRDp2w7eQdRTlI/WnNhY4JOofpMf2zwABgBWtAu0VooQcZZTpQruigF/z6xYkBk3UHkjeqxzMN3d1EqGusxJoqgdTouZ5X5QTTIee9nQ3LEhWnRSXDx7Y0ttR1BGfcdqHopO4IBqAhbkKRjF5zj7OD8cG35omywUbZtOJnftiI0nFcRaxbXo0voDfLD0S6+AC2R3tKpqjkNX6/91hrRFglUakyMcZU/xleqbv6+Lr3YD8PsBTub6lIoZ2lS38fL18Aon458fbc0BPHtenfhKj5-----END CERTIFICATE-----"
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

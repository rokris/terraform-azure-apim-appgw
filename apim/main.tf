# Create Subnet for APIM
resource "azurerm_subnet" "apim-subnet" {
  name                      = var.apim_subnet_name
  resource_group_name       = var.apim_rg
  virtual_network_name      = var.vnet_name
  address_prefixes          = [var.apim_subnet_iprange]
}

resource "azurerm_network_security_group" "apim-nsg" {
  name                = var.apim_nsg_name
  location            = var.location
  resource_group_name = var.apim_rg
  tags                = var.tags
}

# Create NSG rules
resource "azurerm_network_security_rule" "rules" {
  for_each                    = var.nsg_rules
  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_address_prefix       = each.value.source_address_prefix
  source_port_range           = each.value.source_port_range
  destination_address_prefix  = each.value.destination_address_prefix
  destination_port_range      = each.value.destination_port_range
  resource_group_name         = var.apim_rg
  network_security_group_name = azurerm_network_security_group.apim-nsg.name
}

resource "azurerm_subnet_network_security_group_association" "ass" {
  subnet_id                 = azurerm_subnet.apim-subnet.id
  network_security_group_id = azurerm_network_security_group.apim-nsg.id
}

resource "azurerm_public_ip" "pip" {
  name                = var.apim_pip_name
  resource_group_name = var.apim_rg
  location            = var.location
  allocation_method   = "Static"
  domain_name_label   = "apim"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_api_management" "apim" {
  name                 = var.apim_name
  location             = var.location
  resource_group_name  = var.apim_rg
  publisher_email      = var.publisher_email
  publisher_name       = var.publisher_name
  sku_name             = var.sku
  tags                 = var.tags
  virtual_network_type = "Internal"
  depends_on = [
    azurerm_network_security_rule.rules
  ]
  
  sign_up {
    enabled = true

    terms_of_service {
      consent_required = true
      enabled         = true
    }
  }
  
  virtual_network_configuration {
    subnet_id = azurerm_subnet.apim-subnet.id
  }

  # Set the public IP address ID
  public_ip_address_id = azurerm_public_ip.pip.id

  protocols {
    enable_http2 = true
  }

  identity {
    type = "SystemAssigned"
  }
}

# Add a DEMO API
resource "azurerm_api_management_api" "example" {
  name                  = "swagger-petstore-mock"
  resource_group_name   = var.apim_rg
  api_management_name   = var.apim_name
  revision              = "1"
  display_name          = "Swagger Petstore Mock"
  path                  = "petstore"
  protocols             = ["https"]
  subscription_required = true
  
  subscription_key_parameter_names {
    header = "Ocp-Apim-Subscription-Key"
    query  = "subscription-key"
  }
  
  depends_on = [
    azurerm_api_management.apim
    ]

  import {
    content_format = "swagger-link-json"
    content_value  = "https://petstore.swagger.io/v2/swagger.json"
  }
}

resource "azurerm_api_management_api_policy" "inbound_policy" {
  api_name            = azurerm_api_management_api.example.name
  api_management_name = var.apim_name
  resource_group_name = var.apim_rg

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <mock-response status-code="200" content-type="application/json" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>	
	XML
}  

#Read the External Key Vault
data "azurerm_key_vault" "production_keyvault" {
  name                = var.keyvault
  resource_group_name = var.apim_rg
}

resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id = data.azurerm_key_vault.production_keyvault.id
  tenant_id    = azurerm_api_management.apim.identity.0.tenant_id
  object_id    = azurerm_api_management.apim.identity.0.principal_id

  secret_permissions = [
    "Get", "List",
  ]

  certificate_permissions = [
    "Get", "List",
  ]
}

#Read the Certificate
data "azurerm_key_vault_certificate" "prod_certificate" {
  name         = var.certificate_name
  key_vault_id = data.azurerm_key_vault.production_keyvault.id
  depends_on = [ azurerm_key_vault_access_policy.policy ]
}

resource "azurerm_api_management_custom_domain" "apim" {
  api_management_id = azurerm_api_management.apim.id

  gateway {
    host_name    = var.gateway_dns_name
    key_vault_id = data.azurerm_key_vault_certificate.prod_certificate.versionless_secret_id
  }

  developer_portal {
    host_name    = var.developer_portal_dns_name
    key_vault_id = data.azurerm_key_vault_certificate.prod_certificate.versionless_secret_id
  }

  management {
    host_name    = var.management_dns_name
    key_vault_id = data.azurerm_key_vault_certificate.prod_certificate.versionless_secret_id
  }
}

# Create public IP
resource "azurerm_public_ip" "nat_pip" {
  name                = var.nat_pip_name
  resource_group_name = var.apim_rg
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Create the NAT Gateway
resource "azurerm_nat_gateway" "nat" {
  name                = var.nat_gw_name
  location            = var.location
  resource_group_name = var.apim_rg
  sku_name            = "Standard"
  idle_timeout_in_minutes = 4
  tags = var.tags
}

# Associate a public IP
resource "azurerm_nat_gateway_public_ip_association" "example" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}

# Associate a subnet to NAT gateway
resource "azurerm_subnet_nat_gateway_association" "association" {
  subnet_id      = azurerm_subnet.apim-subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}
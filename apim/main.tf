# Create Subnet for APIM
resource "azurerm_subnet" "apim-subnet" {
  name                      = var.apim_subnet_name
  resource_group_name       = var.apim_rg
  virtual_network_name      = var.vnet_name
  address_prefixes          = [var.apim_subnet_iprange]
}

data "azurerm_network_security_group" "apim-nsg" {
  name                = var.apim_nsg_name
  resource_group_name = var.apim_rg
}

resource "azurerm_subnet_network_security_group_association" "ass" {
  subnet_id                 = azurerm_subnet.apim-subnet.id
  network_security_group_id = data.azurerm_network_security_group.apim-nsg.id
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
  #operation_id        = azurerm_api_management_api_operation.api-foo.operation_id

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

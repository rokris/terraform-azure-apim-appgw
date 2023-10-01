terraform {
  required_version = ">=1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }

    domeneshop = {
      source  = "innovationnorway/domeneshop"
      version = ">= 0.1.0"
    }
  }
}

provider "azurerm" {
  features {}

  # client_id       = "00000000-0000-0000-0000-000000000000"
  # client_secret   = var.client_secret
  # tenant_id       = "10000000-0000-0000-0000-000000000000"
  # subscription_id = "20000000-0000-0000-0000-000000000000"
}

data "azurerm_key_vault_secret" "domeneshop_api_token" {
  name         = "domeneshop-api-token"
  key_vault_id = data.azurerm_key_vault.production_keyvault.id
}

data "azurerm_key_vault_secret" "domeneshop_api_secret" {
  name         = "domeneshop-api-secret"
  key_vault_id = data.azurerm_key_vault.production_keyvault.id
}

provider "domeneshop" {
  token  = data.azurerm_key_vault_secret.domeneshop_api_token.value
  secret = data.azurerm_key_vault_secret.domeneshop_api_secret.value
}
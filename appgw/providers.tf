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

provider "domeneshop" {
  token  = var.DOMENESHOP_API_TOKEN
  secret = var.DOMENESHOP_API_SECRET
}
terraform {
  required_version = ">=1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }

    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
  }
}
provider "azurerm" {
  features {}
}

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}
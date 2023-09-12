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
  # Staging certificate for test
  #server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  
  # Production certificate
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
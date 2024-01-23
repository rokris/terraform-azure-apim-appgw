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

  # client_id       = "00000000-0000-0000-0000-000000000000"
  # client_secret   = var.client_secret
  # tenant_id       = "10000000-0000-0000-0000-000000000000"
  # subscription_id = "20000000-0000-0000-0000-000000000000"
}

provider "acme" {
  server_url = var.environment == "staging" ? local.letsencrypt-staging : local.letsencrypt-production

  # Staging certificate for test
  #server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"

  # Production certificate
  #server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

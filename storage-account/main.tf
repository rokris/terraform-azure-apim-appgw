terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.1"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "tfstate" {
  name = "ng-ti-test-rokris-rg"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "ngtitestrokristfstate"
  resource_group_name      = data.azurerm_resource_group.tfstate.name
  location                 = data.azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    owner       = "Roger Kristiansen"
    environment = "Lab"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
  depends_on            = [azurerm_storage_account.tfstate]
}

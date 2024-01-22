terraform {
  backend "azurerm" {
    resource_group_name  = "ng-ti-test-rokris-rg"
    storage_account_name = "ngtitestrokristfstate"
    container_name       = "tfstate"
    key                  = "demo_petstore_mock.terraform.tfstate"
  }
}

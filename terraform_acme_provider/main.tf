locals {
  algorithm = "RSA"
  bits = 2048
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "roger.kristiansen@norgesgruppen.no"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = "*.snorkelground.no"
  #subject_alternative_names = [""]

  dns_challenge {
    provider = "domeneshop"
    
    config = {
      DOMENESHOP_API_TOKEN           = ""
      DOMENESHOP_API_SECRET          = ""
      #DOMENESHOP_HTTP_TIMEOUT        = ""
      #DOMENESHOP_POLLING_INTERVAL    = ""
      #DOMENESHOP_PROPAGATION_TIMEOUT = ""
    }
  }
}

#Read the External Key Vault
data "azurerm_key_vault" "production_keyvault" {
  name                = "ng-ti-test-rokris-kv"
  resource_group_name = "ng-ti-test-rokris-rg"
}

resource "azurerm_key_vault_certificate" "kv_cert" {
  name = "star-snorkelground"
  key_vault_id = data.azurerm_key_vault.production_keyvault.id

  certificate {
    contents = acme_certificate.certificate.certificate_p12
    password = ""
  }

  certificate_policy {
    issuer_parameters {
      name = "Unknown"
    }

    key_properties {
      key_size = local.bits
      key_type = local.algorithm
      exportable = true
      reuse_key = true
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}
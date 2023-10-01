resource "tls_private_key" "private_key" {
  algorithm = var.cert_algorithm
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.email_address
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = var.cert_cn
  subject_alternative_names = [var.cert_sub == "" ? var.cert_cn : var.cert_sub]

  dns_challenge {
    provider = "domeneshop"

    config = {
      DOMENESHOP_API_TOKEN  = var.DOMENESHOP_API_TOKEN
      DOMENESHOP_API_SECRET = var.DOMENESHOP_API_SECRET
      #DOMENESHOP_HTTP_TIMEOUT        = ""
      #DOMENESHOP_POLLING_INTERVAL    = ""
      #DOMENESHOP_PROPAGATION_TIMEOUT = ""
    }
  }
}

#Read the External Key Vault
data "azurerm_key_vault" "production_keyvault" {
  name                = var.key_vault
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault_certificate" "kv_cert" {
  name         = var.cert_name
  key_vault_id = data.azurerm_key_vault.production_keyvault.id
  tags         = var.tags

  certificate {
    contents = acme_certificate.certificate.certificate_p12
    password = ""
  }

  certificate_policy {
    issuer_parameters {
      name = "Unknown"
    }

    key_properties {
      key_size   = var.cert_bits
      key_type   = var.cert_algorithm
      exportable = true
      reuse_key  = true
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}

data "azurerm_key_vault_certificate_data" "example" {
  name         = var.cert_name
  key_vault_id = data.azurerm_key_vault.production_keyvault.id
  depends_on   = [azurerm_key_vault_certificate.kv_cert]
}

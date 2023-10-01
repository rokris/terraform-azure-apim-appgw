output "certificate_thumbprint" {
  value = azurerm_key_vault_certificate.kv_cert.thumbprint
}

output "pem" {
  value = data.azurerm_key_vault_certificate_data.example.pem
}

output "private_key_pem" {
  value = nonsensitive(lookup(acme_certificate.certificate, "private_key_pem"))
}
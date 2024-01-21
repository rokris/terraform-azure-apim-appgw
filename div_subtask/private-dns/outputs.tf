output "dns_zone_name" {
  value = azurerm_private_dns_zone.dns.name
}

output "tags" {
  value = azurerm_private_dns_zone.dns.tags
}


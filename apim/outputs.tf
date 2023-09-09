output "api_management_service_name" {
  value = azurerm_api_management.apim.name
}

output "gateway_dns_domain" {
  value = azurerm_api_management_custom_domain.apim.gateway[0].host_name
}

output "portal_dns_domain" {
  value = azurerm_api_management_custom_domain.apim.developer_portal[0].host_name  
}

output "management_dns_domain" {
  value = azurerm_api_management_custom_domain.apim.management[0].host_name  
}

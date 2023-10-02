#Read the Virtual net
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.private_dns_rg
}

#Read the APIM private IP
data "azurerm_api_management" "private-ip" {
  name                = var.apim_name
  resource_group_name = var.private_dns_rg
}

resource "azurerm_private_dns_zone" "dns" {
  name                = var.dns_zone
  resource_group_name = var.private_dns_rg
  tags                = var.tags
}

#Create a Virtual network link to subnet
resource "azurerm_private_dns_zone_virtual_network_link" "virtual-link" {
  name                  = "${var.dns_zone}-link"
  resource_group_name   = var.private_dns_rg
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}

#Create DNS Records
resource "azurerm_private_dns_a_record" "zone" {
  for_each            = { for record in local.dns_records : record.name => record }
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  zone_name           = each.value.zone_name
  ttl                 = each.value.ttl
  records             = [data.azurerm_api_management.private-ip.private_ip_addresses[0]]
  depends_on          = [azurerm_private_dns_zone.dns]
}

# #Create DNS Records
# resource "azurerm_private_dns_cname_record" "zone" {
#   for_each            = { for record in local.dns_records : record.name => record }
#   name                = each.value.name
#   resource_group_name = each.value.resource_group_name
#   zone_name           = each.value.zone_name
#   ttl                 = each.value.ttl
#   record              = "${var.apim_name}.azure-api.net"
#   depends_on          = [azurerm_private_dns_zone.dns]
# }
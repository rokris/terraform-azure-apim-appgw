#Read the Virtual net
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
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
  for_each            = { for record in var.dns_records : record.name => record }
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  zone_name           = each.value.zone_name
  ttl                 = each.value.ttl
  records             = each.value.records
  depends_on          = [azurerm_private_dns_zone.dns]
}
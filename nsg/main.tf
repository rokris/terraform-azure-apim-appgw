resource "azurerm_network_security_group" "apim-nsg" {
  name                = var.apim_nsg_name
  location            = var.location
  resource_group_name = var.apim_rg
  tags                = var.tags
}

# NSG rules
resource "azurerm_network_security_rule" "rules" {
  for_each                    = var.nsg_rules
  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_address_prefix       = each.value.source_address_prefix
  source_port_range           = each.value.source_port_range
  destination_address_prefix  = each.value.destination_address_prefix
  destination_port_range      = each.value.destination_port_range
  resource_group_name         = var.apim_rg
  network_security_group_name = azurerm_network_security_group.apim-nsg.name
}
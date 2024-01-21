# Create public IP
resource "azurerm_public_ip" "pip" {
  name                = var.nat_pip_name
  resource_group_name = var.nat_rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

data "azurerm_subnet" "apim_snet" {
  name                 = var.apim_snet_name
  resource_group_name  = var.nat_rg_name
  virtual_network_name = var.vnet_name
}

# Create the NAT Gateway
resource "azurerm_nat_gateway" "nat" {
  name                    = var.nat_gw_name
  location                = var.location
  resource_group_name     = var.nat_rg_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4
  tags                    = var.tags
}

# Associate a public IP
resource "azurerm_nat_gateway_public_ip_association" "example" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.pip.id
}

# Associate a subnet to NAT gateway
resource "azurerm_subnet_nat_gateway_association" "association" {
  subnet_id      = data.azurerm_subnet.apim_snet.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

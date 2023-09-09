output "gateway_frontend_ip" {
  value = "IP = ${azurerm_public_ip.pip.ip_address}"
}
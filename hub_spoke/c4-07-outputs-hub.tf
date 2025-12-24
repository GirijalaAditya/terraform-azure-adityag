output "firewall_private_ip_address" {
  value = azurerm_firewall.afw.ip_configuration.0.private_ip_address
}

output "firewall_public_ip_address" {
  value = module.azure_firewall_public_ip.public_ip_address
}
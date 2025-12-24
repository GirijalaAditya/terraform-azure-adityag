output "firewall_region3_private_ip_address" {
  value = azurerm_firewall.afw_region3.ip_configuration.0.private_ip_address
}

output "firewall_region3_public_ip_address" {
  value = module.azure_firewall_public_ip_region3.public_ip_address
}
output "firewall_region2_private_ip_address" {
  value = azurerm_firewall.afw_region2.ip_configuration.0.private_ip_address
}

output "firewall_region2_public_ip_address" {
  value = module.azure_firewall_public_ip_region2.public_ip_address
}
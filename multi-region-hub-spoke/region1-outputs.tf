output "firewall_region1_private_ip_address" {
  value = azurerm_firewall.afw_region1.ip_configuration.0.private_ip_address
}

output "firewall_region1_public_ip_address" {
  value = module.azure_firewall_public_ip_region1.public_ip_address
}
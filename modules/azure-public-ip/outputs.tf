output "public_ip_address_id" {
  description = "Public IP Address ID"
  value       = azurerm_public_ip.pip.id
}

output "public_ip_address" {
  description = "Public IP Address"
  value       = azurerm_public_ip.pip.ip_address
}
variable "terminal_server_virtual_network_address_space" {
  type        = string
  description = "Terminal Server Virtual Network Address Space"
  default     = "10.0.1.0/24"
}

// Resource Group - Terminal Server
module "resource_group_terminal_server" {
  source   = "../modules/resource-group"
  name     = "rg-terminal-server-${var.region2}"
  location = var.region2
  tags     = local.common_tags
}

// Virtual Network -  Terminal Server
resource "azurerm_virtual_network" "vnet_terminal_server" {
  name                = "vnet-terminal-server-${module.resource_group_terminal_server.resource_group_location}"
  location            = module.resource_group_terminal_server.resource_group_location
  resource_group_name = module.resource_group_terminal_server.resource_group_name
  address_space       = [var.terminal_server_virtual_network_address_space]
  tags                = local.common_tags
}

// Subnet Workloads - Terminal Server
resource "azurerm_subnet" "subnet_terminal_server" {
  name                                          = "snet-workloads"
  address_prefixes                              = [cidrsubnet(var.terminal_server_virtual_network_address_space, 2, 0)]
  virtual_network_name                          = azurerm_virtual_network.vnet_terminal_server.name
  resource_group_name                           = module.resource_group_terminal_server.resource_group_name
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = false
  default_outbound_access_enabled               = false
}

resource "azurerm_virtual_hub_connection" "vhub_connection_terminal_server" {
  name                      = "vhub-connection-${azurerm_virtual_network.vnet_terminal_server.name}"
  virtual_hub_id            = azurerm_virtual_hub.vhub_region2.id
  remote_virtual_network_id = azurerm_virtual_network.vnet_terminal_server.id
  internet_security_enabled = true
}

// Private DNS Resolver - Virtual Network Link
resource "azurerm_private_dns_resolver_virtual_network_link" "private_dns_resolver_virtual_network_link_vnet_terminal_server_region2" {
  name                      = "link-${azurerm_virtual_network.vnet_terminal_server.name}"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.private_dns_resolver_dns_forwarding_ruleset_region2.id
  virtual_network_id        = azurerm_virtual_network.vnet_terminal_server.id
}

// Windows 
module "vm_windows_terminal_server" {
  source              = "../modules/virtual-machine/windows"
  vm_name             = "vm-win-terminal"
  computer_name       = "vm-win-terminal"
  resource_group_name = module.resource_group_terminal_server.resource_group_name
  location            = module.resource_group_terminal_server.resource_group_location
  vm_subnet_id        = azurerm_subnet.subnet_terminal_server.id
  vm_size             = "Standard_B2ms"
  tags                = local.common_tags
}

// Linux
module "vm_linux_terminal_server" {
  source              = "../modules/virtual-machine/linux"
  vm_name             = "vm-lin-terminal"
  resource_group_name = module.resource_group_terminal_server.resource_group_name
  location            = module.resource_group_terminal_server.resource_group_location
  vm_subnet_id        = azurerm_subnet.subnet_terminal_server.id
  tags                = local.common_tags
}
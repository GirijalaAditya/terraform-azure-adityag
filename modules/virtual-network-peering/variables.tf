variable "subscription_id" {
  description = "Subscription ID"
  type = string
}

variable "virtual_resource_group_network_name" {
  description = "Virtual Network Resource Group Name"
  type = string
}

variable "virtual_network_name" {
  description = "Virtual Network Name"
  type = string
}

variable "remote_virtual_network_name" {
  description = "Remote Virtual Network Name"
  type = string
}

variable "remote_virtual_resource_group_network_name" {
  description = "Remote Virtual Network Resource Group Name"
  type = string
}

variable "peering_name" {
  description = "Virtual Network Peering Name"
  type = string
}

variable "virtual_network_gateway_exists" {
  description = "Virtual Network Gateway Exists"
  type = bool
}

data "azurerm_virtual_network" "remote_virtual_network" {
  name = var.remote_virtual_network_name
  resource_group_name = var.remote_virtual_resource_group_network_name
}


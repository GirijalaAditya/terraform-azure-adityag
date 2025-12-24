// Resource Group
variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Resource Group Location"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "virtual_network_address_space" {
  type        = string
  description = "Virtual Network Address Space"
}

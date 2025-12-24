variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
  nullable    = false
}

variable "location" {
  type        = string
  description = "VNET Location"
  nullable    = false
}

variable "name" {
  type        = string
  description = "VNET Name"
  nullable    = false
}

variable "address_space" {
  type        = list(string)
  description = "VNET Address Space"
}

variable "subnets" {
  description = "Map of subnets to create in the VNET. Key is subnet name, value is address spaces."
  type        = map(string)
}

variable "tags" {
  type        = map(string)
  description = "The tags to associate with your network and subnets."
}
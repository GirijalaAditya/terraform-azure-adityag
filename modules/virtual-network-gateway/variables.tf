variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Resource Group Location"
  type        = string
}

variable "virtual_network_name" {
  description = "Virtual Network Name"
  type = string
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}

// Virtual Network Gateway
variable "type" {
  description = "Virtual Network Gateway Type"
  type = string
  default = "Vpn"
}

variable "sku" {
  description = "Virtual Network Gateway SKU"
  type = string
}

variable "generation" {
  description = "Virtual Network Gateway Generation"
  type = string
}

variable "active_active" {
  description = "Active - Active Mode"
  type = bool
}

variable "enable_bgp" {
  description = "Enable BGP"
  type = bool
}

variable "bgp_asn" {
  description = "BGN ASN"
  type = number
}
variable "region2" {
  description = "The Azure region for the first virtual hub"
  type        = string
  default     = "westeurope"
}

variable "vhub_address_space_region2" {
  type        = string
  description = "Virtual Hub Address Space"
}

variable "vnet_onprem_address_space_region2" {
  type        = string
  description = "Virtual Network Address Space"
}

variable "vpn_client_address_pool_region2" {
  type        = string
  description = "VPN Client Address Pool Region 1"
}

variable "vng_onprem_bgp_asn_region2" {
  type        = number
  description = "On Prem VNG Region 1 BGP ASN"
}

variable "vnet_dns_address_space_region2" {
  type        = string
  description = "Virtual Network Address Space"
}

variable "vnet_apps_address_space_region2" {
  type        = string
  description = "Virtual Network Address Space"
}
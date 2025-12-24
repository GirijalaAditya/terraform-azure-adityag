variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
  nullable    = false
}

variable "location" {
  type        = string
  description = "Resource Group Location"
  nullable    = false
}

variable "name" {
  type        = string
  description = "Bastion Name"
  nullable    = false
}

variable "bastion_subnet_id" {
  type = string
  description = "Bastion Subnet ID"
  nullable = false
}

variable "sku" {
  type    = string
  default = "Standard"
  nullable = false
  validation {
    condition     = can(regex("^(Developer|Basic|Standard)$", var.sku))
    error_message = "Valid values are Developer, Basic or Standard"
  }
}

variable "zones" {
  type = list(string)
  description = "Zones"
  default = ["1","2","3"]
}

variable "tags" {
  type        = map(string)
  description = "Resource Tags"
}
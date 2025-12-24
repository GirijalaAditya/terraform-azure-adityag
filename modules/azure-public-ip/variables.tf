variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type = string
  description = "Location"
}

variable "name" {
  type        = string
  description = "Public IP Name"
}

variable "zones" {
  type = list(string)
  description = "Zones"
  default = ["1","2","3"]
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}
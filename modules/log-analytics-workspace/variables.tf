variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Location"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Log Analytics Workspace Name"
  type = string
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}
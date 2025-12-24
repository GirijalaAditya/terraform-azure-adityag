// Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                            = var.log_analytics_workspace_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  sku                             = "PerGB2018"
  retention_in_days               = 30
  allow_resource_only_permissions = false
  internet_ingestion_enabled      = true
  internet_query_enabled          = true
  tags = var.tags
}

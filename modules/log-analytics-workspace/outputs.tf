output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.id
}

output "log_analytics_workspace_name" {
  description = "Log Analytics Workspace Name"
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.name
}
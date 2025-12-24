data "azurerm_subscription" "current" {}

data "azurerm_kubernetes_service_versions" "current" {
  location        = module.resource_group.resource_group_location
  include_preview = false
}

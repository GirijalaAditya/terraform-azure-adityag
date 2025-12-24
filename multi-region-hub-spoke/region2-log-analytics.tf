module "log_analytics_workspace_region2" {
  source                       = "../modules/log-analytics-workspace"
  resource_group_name          = module.resource_group_hub_region2.resource_group_name
  location                     = var.region2
  log_analytics_workspace_name = "log-${var.region2}"
  tags                         = local.common_tags
}
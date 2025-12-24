module "log_analytics_workspace_region3" {
  source                       = "../modules/log-analytics-workspace"
  resource_group_name          = module.resource_group_hub_region3.resource_group_name
  location                     = var.region3
  log_analytics_workspace_name = "log-${var.region3}"
  tags                         = local.common_tags
}
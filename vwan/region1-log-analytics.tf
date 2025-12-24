module "log_analytics_workspace_region1" {
  source                       = "../modules/log-analytics-workspace"
  resource_group_name          = module.resource_group_region1.resource_group_name
  location                     = var.region1
  log_analytics_workspace_name = "log-${var.region1}"
  tags                         = local.common_tags
}
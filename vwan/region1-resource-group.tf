// Shared Resource Group - Region 1
module "resource_group_region1" {
  source   = "../modules/resource-group"
  name     = "rg-shared-${var.region1}"
  location = var.region1
  tags     = local.common_tags
}

# On-Prem Resource Group - Region 1
module "resource_group_onprem_region1" {
  source   = "../modules/resource-group"
  name     = "rg-onprem-${var.region1}"
  location = var.region1
  tags     = local.common_tags
}
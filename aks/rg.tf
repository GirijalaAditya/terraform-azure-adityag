// Resource Group
module "resource_group" {
  source   = "../modules/resource-group"
  name     = "${var.resource_group_name}-${var.location}"
  location = var.location
  tags     = local.common_tags
}
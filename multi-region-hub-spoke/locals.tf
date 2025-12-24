# Local Values
locals {
  owner                = var.business_divsion
  environment          = var.environment
  resource_name_prefix = "${var.business_divsion}-${var.environment}"
  common_tags = {
    owner       = local.owner
    environment = local.environment
  }
} 
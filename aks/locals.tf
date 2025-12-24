# Local Values
locals {
  environment = var.environment
  common_tags = {
    owner       = "DevOps"
    environment = local.environment
  }
} 
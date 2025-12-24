terraform {
  required_version = "~> 1.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.44"
    }
  }
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  environment = "public"
  use_msi     = false
  use_cli     = true
  use_oidc    = false
}
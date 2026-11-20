terraform {
  required_version = ">= 1.9, < 2.0"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
  }
}

provider "azapi" {}

data "azapi_client_config" "current" {}

# Configure AzureRM in the caller only while upgrading from a module version that used it.

# Importing the Azure naming module to ensure resources have unique CAF compliant names.
module "naming" {
  source  = "Azure/avm-utl-naming/azure"
  version = "0.3.0"
}

module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.13.0"

  location         = var.location
  enable_telemetry = var.enable_telemetry
  is_recommended   = true
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}

module "resource_group" {
  source = "../../"

  location           = module.regions.regions[random_integer.region_index.result].name
  name               = module.naming.names.resource_group.name_unique
  parent_id          = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
  enable_telemetry   = var.enable_telemetry
  ignore_tag_changes = true
  tags = {
    Environment = "Non-Prod"
    Owner       = "Platform"
  }
}

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

# Importing the Azure naming module to ensure resources have unique CAF compliant names.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
}

module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.12.0"

  is_recommended = true
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}

# A second resource group used as the "managing" resource. In a real scenario this would be
# a managed application, Databricks workspace, or another service that owns the lifecycle of
# the managed resource group.
resource "azapi_resource" "manager" {
  location  = module.regions.regions[random_integer.region_index.result].name
  name      = "${module.naming.resource_group.name_unique}-mgr"
  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
  type      = "Microsoft.Resources/resourceGroups@2025-04-01"
  body = {
    properties = {}
  }
}

module "resource_group" {
  source = "../../"

  location   = module.regions.regions[random_integer.region_index.result].name
  name       = module.naming.resource_group.name_unique
  managed_by = azapi_resource.manager.id
}

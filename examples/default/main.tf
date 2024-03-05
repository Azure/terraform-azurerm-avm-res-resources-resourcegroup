# Importing the Azure naming module to ensure resources have unique CAF compliant names.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
}

module "resource_group" {
  source   = "../../"
  location = var.location
  name     = module.naming.resource_group.name_unique
}
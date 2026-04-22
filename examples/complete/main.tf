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

resource "azapi_resource" "dep" {
  location  = module.regions.regions[random_integer.region_index.result].name
  name      = "${module.naming.resource_group.name_unique}-dep"
  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
  type      = "Microsoft.Resources/resourceGroups@2025-04-01"
  body = {
    properties = {}
  }
}

resource "azapi_resource" "dep_uai" {
  location               = azapi_resource.dep.location
  name                   = module.naming.user_assigned_identity.name_unique
  parent_id              = azapi_resource.dep.id
  type                   = "Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31"
  body                   = {}
  response_export_values = ["properties.principalId"]
}

module "resource_group" {
  source = "../../"

  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
  lock = {
    kind = "CanNotDelete"
    name = "myCustomLockName"

  }
  role_assignments = {
    "roleassignment1" = {
      principal_id               = azapi_resource.dep_uai.output.properties.principalId
      role_definition_id_or_name = "Reader"
      principal_type             = "ServicePrincipal"
      description                = "Reader role assignment for the user assigned identity"
    },
    "role_assignment2" = {
      role_definition_id_or_name       = "Storage Blob Data Reader"
      principal_id                     = azapi_resource.dep_uai.output.properties.principalId
      skip_service_principal_aad_check = false
      principal_type                   = "ServicePrincipal"
      description                      = "Storage Blob Data Reader role assignment with conditional access on blob list operations"
      condition_version                = "2.0"
      condition                        = <<-EOT
(
 (
  !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND NOT SubOperationMatches{'Blob.List'})
 )
 OR
 (
  @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:name] StringEquals 'blobs-example-container'
 )
)
EOT
    }
  }
  tags = {
    "hidden-title" = "This is visible in the resource name"
    Environment    = "Non-Prod"
    Role           = "DeploymentValidation"
  }
}


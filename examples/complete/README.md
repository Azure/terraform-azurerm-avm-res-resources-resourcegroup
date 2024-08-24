<!-- BEGIN_TF_DOCS -->
# Complete Resource Group Deployment

This module is used to deploy an Azure Resource Group with all available functionality

```hcl
terraform {
  required_version = ">= 1.5.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.71, <= 3.108.0 "
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Importing the Azure naming module to ensure resources have unique CAF compliant names.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = " >= 0.4.0"
}

module "regions" {
  source  = "Azure/regions/azurerm"
  version = ">= 0.3.0"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}

resource "azurerm_resource_group" "dep" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = "${module.naming.resource_group.name_unique}-dep"
}

resource "azurerm_user_assigned_identity" "dep_uai" {
  location            = azurerm_resource_group.dep.location
  name                = module.naming.user_assigned_identity.name_unique
  resource_group_name = azurerm_resource_group.dep.name
}

module "resource_group" {
  source   = "../../"
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
  tags = {
    "hidden-title" = "This is visible in the resource name"
    Environment    = "Non-Prod"
    Role           = "DeploymentValidation"
  }
  lock = {
    kind = "CanNotDelete"
    name = "myCustomLockName"

  }
  role_assignments = {
    "roleassignment1" = {
      principal_id               = azurerm_user_assigned_identity.dep_uai.principal_id
      role_definition_id_or_name = "Reader"
    },
    "role_assignment2" = {
      role_definition_id_or_name       = "/providers/Microsoft.Authorization/roleDefinitions/2a2b9908-6ea1-4ae2-8e65-a410df84e7d1" # Storage Blob Data Reader Role Guid 
      principal_id                     = azurerm_user_assigned_identity.dep_uai.principal_id
      skip_service_principal_aad_check = false
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
}

```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.5.2)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.71, <= 3.108.0 )

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0, < 4.0.0)

## Resources

The following resources are used by this module:

- [azurerm_resource_group.dep](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_user_assigned_identity.dep_uai](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [random_integer.region_index](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_name"></a> [name](#output\_name)

Description: The name of the resource group

### <a name="output_resource"></a> [resource](#output\_resource)

Description: This is the full output for the resource group.

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: The resource Id of the resource group

## Modules

The following Modules are called:

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version:  >= 0.4.0

### <a name="module_regions"></a> [regions](#module\_regions)

Source: Azure/regions/azurerm

Version: >= 0.3.0

### <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Footer Data
<!-- END_TF_DOCS -->
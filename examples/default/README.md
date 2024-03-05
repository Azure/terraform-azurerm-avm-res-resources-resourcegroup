<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-ecm-res-resource-resourcegroup

This module is used to deploy an Azure Resource Group

```hcl
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
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.5.2)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.71.0)

## Providers

No providers.

## Resources

No resources.

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: Required. The Azure region for deployment of the this resource.

Type: `string`

Default: `"eastus"`

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

Version: 0.4.0

### <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Footer Data
<!-- END_TF_DOCS -->
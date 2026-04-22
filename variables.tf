variable "location" {
  type        = string
  description = "Required. The Azure region for deployment of the this resource."
  nullable    = false
}

variable "name" {
  type        = string
  description = "Required. The name of the this resource."

  validation {
    condition     = can(regex("^[a-zA-Z0-9_().-]{1,89}[a-zA-Z0-9_()-]$", var.name))
    error_message = <<ERROR_MESSAGE
    The resource group name must meet the following requirements:
    - `Between 1 and 90 characters long.`
    - `Can only contain Alphanumerics, underscores, parentheses, hyphens, periods.`
    - `Cannot end in a period`
    ERROR_MESSAGE
  }
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
  Controls the Resource Lock configuration for this resource. The following properties can be specified:

  - `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
  - `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
  DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "Lock kind must be either `\"CanNotDelete\"` or `\"ReadOnly\"`."
  }
}

variable "managed_by" {
  type        = string
  default     = null
  description = "(Optional) The ID of the resource or application that manages this resource group. Setting this property indicates that the resource group is managed by another service (for example a managed application or a Databricks workspace)."

  validation {
    condition     = var.managed_by == null || can(regex("^/.+/.+", var.managed_by))
    error_message = "`managed_by` must be a valid Azure resource ID starting with `/` and containing at least two `/` separated segments."
  }
}

variable "retry" {
  type = object({
    error_message_regex  = optional(list(string), ["409 Conflict"])
    interval_seconds     = optional(number, null)
    max_interval_seconds = optional(number, null)
  })
  default     = {}
  description = <<DESCRIPTION
The retry configuration applied to the underlying `azapi_resource` resources (resource group, lock, role assignments).

- `error_message_regex` - (Optional) A list of regular expressions to match against error messages. If any of the regular expressions match, the request will be retried. Defaults to `["409"]` to retry on `409 Conflict` responses.
- `interval_seconds` - (Optional) The base number of seconds to wait between retries. Defaults to the AzAPI provider default (`10`).
- `max_interval_seconds` - (Optional) The maximum number of seconds to wait between retries. Defaults to the AzAPI provider default (`180`).
DESCRIPTION
}

variable "role_assignment_name_overrides" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
Optional. A map of role assignment names to override the auto-generated names produced by the interfaces module.

The map key must match a key in the `role_assignments` variable. The map value must be a valid UUID (the role assignment resource name in Azure is a GUID).

Example:
```hcl
role_assignment_name_overrides = {
  "roleassignment1" = "00000000-0000-0000-0000-000000000001"
}
```
DESCRIPTION
  nullable    = false

  validation {
    condition = alltrue(
      [for name in values(var.role_assignment_name_overrides) :
        can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", name))
      ]
    )
    error_message = "Each value in `role_assignment_name_overrides` must be a valid GUID (e.g. `00000000-0000-0000-0000-000000000000`)."
  }
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
Optional. A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - (Required) The ID or name of the role definition to assign to the principal.
- `principal_id` - (Required) The ID of the principal to assign the role to.
- `description` - (Optional) The description of the role assignment.
- `skip_service_principal_aad_check` - (Optional) If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - (Optional) The condition which will be used to scope the role assignment.
- `condition_version` - (Optional) The version of the condition syntax. Valid values are '2.0'.
- `delegated_managed_identity_resource_id` - (Optional) The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created. NOTE:
this field is only used in cross tenant scenario.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Example Input:
```hcl
role_assignments = {
  "role_assignment1" = {
    role_definition_id_or_name = "Reader"
    principal_id = "4179302c-702e-4de7-a061-beacd0a1be09"

  },
"role_assignment2" = {
  role_definition_id_or_name = "2a2b9908-6ea1-4ae2-8e65-a410df84e7d1" // Storage Blob Data Reader Role Guid
  principal_id = "4179302c-702e-4de7-a061-beacd0a1be09"
  skip_service_principal_aad_check = false
  condition_version = "2.0"
  condition = <<-EOT
(
  (
    !(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})
  )
OR
  (
  @Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId]
  ForAnyOfAnyValues:GuidEquals {4179302c-702e-4de7-a061-beacd0a1be09}
  )
)
AND
(
  (
    !(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})
  )
  OR
  (
    @Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId]
    ForAnyOfAnyValues:GuidEquals {dc887ae1-fe50-4307-be53-213ff08f3c0b}
  )
)
EOT
  }
}
```
DESCRIPTION
  nullable    = false

  validation {
    condition = alltrue(
      [for role in var.role_assignments :
        can(regex("^(/subscriptions/[0-9a-fA-F-]+)?/providers/Microsoft\\.Authorization/roleDefinitions/[0-9a-fA-F-]+$", role.role_definition_id_or_name))
        ||
        can(regex("^[[:alpha:]]+?", role.role_definition_id_or_name))
      ]
    )
    error_message = <<ERROR_MESSAGE
        role_definition_id_or_name must have the following format:
         - Using the role definition Id : `/providers/Microsoft.Authorization/roleDefinitions/<role_guid>`
         - Using the subscription-scoped role definition Id : `/subscriptions/<subscription_id>/providers/Microsoft.Authorization/roleDefinitions/<role_guid>`
         - Using the role name: Reader | "Storage Blob Data Reader"
      ERROR_MESSAGE
  }
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}

variable "timeouts" {
  type = object({
    create = optional(string, null)
    delete = optional(string, null)
    read   = optional(string, null)
    update = optional(string, null)
  })
  default     = {}
  description = <<DESCRIPTION
The timeouts applied to the underlying `azapi_resource` resources (resource group, lock, role assignments).

Each value must be a string parsable as a Go duration (for example `"30s"`, `"5m"`, `"1h30m"`). When `null`, the AzAPI provider default is used.

- `create` - (Optional) Timeout for create operations.
- `delete` - (Optional) Timeout for delete operations.
- `read` - (Optional) Timeout for read operations.
- `update` - (Optional) Timeout for update operations.
DESCRIPTION
  nullable    = false
}

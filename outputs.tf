output "location" {
  description = "The location of the resource group"
  value       = local.resource_group.location
}

output "name" {
  description = "The name of the resource group"
  value       = local.resource_group.name
}

output "resource" {
  description = "This is the full output for the resource group."
  value = merge(local.resource_group, {
    tags = var.ignore_tag_changes ? null : local.resource_group.tags
    resource = var.ignore_tag_changes ? merge(try(local.resource_group.resource, {}), {
      tags = null
    }) : try(local.resource_group.resource, null)
  })
}

output "resource_id" {
  description = "The resource Id of the resource group"
  value       = local.resource_group.id
}

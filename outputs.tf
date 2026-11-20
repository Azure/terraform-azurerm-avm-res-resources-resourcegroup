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
  value = {
    id       = local.resource_group.id
    location = local.resource_group.location
    name     = local.resource_group.name
    tags     = var.ignore_tag_changes ? null : local.resource_group.tags
  }
}

output "resource_id" {
  description = "The resource Id of the resource group"
  value       = local.resource_group.id
}

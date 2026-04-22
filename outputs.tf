output "location" {
  description = "The location of the resource group"
  value       = azapi_resource.this.location
}

output "name" {
  description = "The name of the resource group"
  value       = azapi_resource.this.name
}

output "resource" {
  description = "This is the full output for the resource group."
  value       = azapi_resource.this
}

output "resource_id" {
  description = "The resource Id of the resource group"
  value       = azapi_resource.this.id
}

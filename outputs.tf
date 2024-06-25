output "name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.this.name
}

output "resource_id" {
  description = "The resource Id of the resource group"
  value       = azurerm_resource_group.this.id
}

output "name" {
  description = "The name of the resource group"
  value       = module.resource_group.name
}

# Module owners should include the full resource via a 'resource' output
# https://confluence.ei.leidos.com/display/ECM/Terraform+ECM+Style+Guide#TerraformECMStyleGuide-TFFR2-Category:Outputs-AdditionalTerraformOutputs
output "resource" {
  description = "This is the full output for the resource group."
  value       = module.resource_group
}

output "resource_id" {
  description = "The resource Id of the resource group"
  value       = module.resource_group.resource_id
}

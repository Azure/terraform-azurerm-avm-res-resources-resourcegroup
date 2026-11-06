# Azure Verified Module for Resource Groups

Module to deploy resource groups.

## Upgrading from 0.4.0

Back up state and inspect the upgrade plan before applying. Keep
`ignore_tag_changes` at its default `false` when upgrading an existing
resource group: setting it to `true` changes the resource address and can
plan to replace the group. Changing this setting later has the same risk.
Review the group, lock, role assignments, and outputs for unintended changes.
The `resource` output has an additional `resource` attribute, so consumers
depending on its exact object shape should review it.

The module now requires AzAPI `~> 2.12`. Telemetry uses subscription-scope
Azure deployments instead of ModTM and, when enabled, requires
`Microsoft.Resources/deployments/read`, `write`, and `delete` permissions at
the subscription scope. Existing telemetry state may require the old
providers for one final initialization before it is forgotten without
destroying it. Set `enable_telemetry = false` to opt out.

Older states still using AzureRM resources require a supported cross-provider
state move to AzAPI and the relevant provider configurations. AzAPI must be
able to derive an Azure resource ID from each source state entry. Inspect the
plan for conversion errors or replacement; if conversion is unsupported,
an explicit state migration or import may be required.

For role assignments created by older AzureRM-based versions, set each
`role_assignments` entry's `name` to its existing assignment GUID before
upgrading. Otherwise, a newly generated name may replace the assignment.
The lock body now includes `notes = null`, where v0.4.0 omitted notes.
Older AzureRM-based versions supplied lock notes. Azure's handling of this
null has not been verified; review existing notes and the upgrade plan.

# Disabled until this PR gets merged:
# https://github.com/Azure/tflint-ruleset-avm/pull/127
# The current rule rejects the optional `name` attribute on role_assignments
# that allows callers to pin a deterministic GUID for a role assignment.
rule "role_assignments" {
  enabled = false
}

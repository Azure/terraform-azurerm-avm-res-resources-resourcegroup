locals {
  resource_group = {
    id       = one(concat(azapi_resource.this[*].id, azapi_resource.this_ignore_tag_changes[*].id))
    location = one(concat(azapi_resource.this[*].location, azapi_resource.this_ignore_tag_changes[*].location))
    name     = one(concat(azapi_resource.this[*].name, azapi_resource.this_ignore_tag_changes[*].name))
    tags     = one(concat(azapi_resource.this[*].tags, azapi_resource.this_ignore_tag_changes[*].tags))
  }
}

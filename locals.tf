locals {
  resource_group = {
    id                     = one(concat(azapi_resource.this[*].id, azapi_resource.this_ignore_tag_changes[*].id))
    location               = one(concat(azapi_resource.this[*].location, azapi_resource.this_ignore_tag_changes[*].location))
    name                   = one(concat(azapi_resource.this[*].name, azapi_resource.this_ignore_tag_changes[*].name))
    tags                   = one(concat(azapi_resource.this[*].tags, azapi_resource.this_ignore_tag_changes[*].tags))
    body                   = one(concat(azapi_resource.this[*].body, azapi_resource.this_ignore_tag_changes[*].body))
    output                 = one(concat(azapi_resource.this[*].output, azapi_resource.this_ignore_tag_changes[*].output))
    parent_id              = one(concat(azapi_resource.this[*].parent_id, azapi_resource.this_ignore_tag_changes[*].parent_id))
    type                   = one(concat(azapi_resource.this[*].type, azapi_resource.this_ignore_tag_changes[*].type))
    response_export_values = one(concat(azapi_resource.this[*].response_export_values, azapi_resource.this_ignore_tag_changes[*].response_export_values))
    retry = one(concat(azapi_resource.this[*].retry, azapi_resource.this_ignore_tag_changes[*].retry)) == null ? null : {
      error_message_regex  = one(concat(azapi_resource.this[*].retry, azapi_resource.this_ignore_tag_changes[*].retry)).error_message_regex
      interval_seconds     = one(concat(azapi_resource.this[*].retry, azapi_resource.this_ignore_tag_changes[*].retry)).interval_seconds
      max_interval_seconds = one(concat(azapi_resource.this[*].retry, azapi_resource.this_ignore_tag_changes[*].retry)).max_interval_seconds
    }
    timeouts = var.timeouts
    identity = flatten([
      azapi_resource.this[*].identity,
      azapi_resource.this_ignore_tag_changes[*].identity,
    ])
    create_headers                   = one(concat(azapi_resource.this[*].create_headers, azapi_resource.this_ignore_tag_changes[*].create_headers))
    create_query_parameters          = one(concat(azapi_resource.this[*].create_query_parameters, azapi_resource.this_ignore_tag_changes[*].create_query_parameters))
    delete_headers                   = one(concat(azapi_resource.this[*].delete_headers, azapi_resource.this_ignore_tag_changes[*].delete_headers))
    delete_query_parameters          = one(concat(azapi_resource.this[*].delete_query_parameters, azapi_resource.this_ignore_tag_changes[*].delete_query_parameters))
    read_headers                     = one(concat(azapi_resource.this[*].read_headers, azapi_resource.this_ignore_tag_changes[*].read_headers))
    read_query_parameters            = one(concat(azapi_resource.this[*].read_query_parameters, azapi_resource.this_ignore_tag_changes[*].read_query_parameters))
    update_headers                   = one(concat(azapi_resource.this[*].update_headers, azapi_resource.this_ignore_tag_changes[*].update_headers))
    update_query_parameters          = one(concat(azapi_resource.this[*].update_query_parameters, azapi_resource.this_ignore_tag_changes[*].update_query_parameters))
    ignore_casing                    = one(concat(azapi_resource.this[*].ignore_casing, azapi_resource.this_ignore_tag_changes[*].ignore_casing))
    ignore_missing_property          = one(concat(azapi_resource.this[*].ignore_missing_property, azapi_resource.this_ignore_tag_changes[*].ignore_missing_property))
    ignore_null_property             = one(concat(azapi_resource.this[*].ignore_null_property, azapi_resource.this_ignore_tag_changes[*].ignore_null_property))
    ignore_other_items_in_list       = one(concat(azapi_resource.this[*].ignore_other_items_in_list, azapi_resource.this_ignore_tag_changes[*].ignore_other_items_in_list))
    list_unique_id_property          = one(concat(azapi_resource.this[*].list_unique_id_property, azapi_resource.this_ignore_tag_changes[*].list_unique_id_property))
    locks                            = one(concat(azapi_resource.this[*].locks, azapi_resource.this_ignore_tag_changes[*].locks))
    replace_triggers_external_values = one(concat(azapi_resource.this[*].replace_triggers_external_values, azapi_resource.this_ignore_tag_changes[*].replace_triggers_external_values))
    replace_triggers_refs            = one(concat(azapi_resource.this[*].replace_triggers_refs, azapi_resource.this_ignore_tag_changes[*].replace_triggers_refs))
    schema_validation_enabled        = one(concat(azapi_resource.this[*].schema_validation_enabled, azapi_resource.this_ignore_tag_changes[*].schema_validation_enabled))
    sensitive_body_version           = one(concat(azapi_resource.this[*].sensitive_body_version, azapi_resource.this_ignore_tag_changes[*].sensitive_body_version))
    ignore_body_changes              = null
    sensitive_body                   = null
  }
}

variables {
  location = "eastus"
  name     = "rg-test"
  lock = {
    kind = "CanNotDelete"
  }
}

mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_id          = "00000000-0000-0000-0000-000000000000"
      subscription_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
      tenant_id                = "00000000-0000-0000-0000-000000000000"
    }
  }

  mock_data "azapi_resource_list" {
    defaults = {
      output = {
        results = [
          {
            id        = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7"
            role_name = "Reader"
          },
          {
            id        = "/providers/Microsoft.Authorization/roleDefinitions/2a2b9908-6ea1-4ae2-8e65-a410df84e7d1"
            role_name = "/providers/Microsoft.Authorization/roleDefinitions/2a2b9908-6ea1-4ae2-8e65-a410df84e7d1"
          },
        ]
      }
    }
  }
}

mock_provider "modtm" {}

mock_provider "random" {}

run "test_valid_resource_group_name" {
  command = plan

  providers = {
    azapi  = azapi
    modtm  = modtm
    random = random
  }

  variables {
    name = "rg-niceresourcegroup-name"
  }
}

run "test_invalid_resource_group_name_end_with_period" {
  command = plan

  providers = {
    azapi  = azapi
    modtm  = modtm
    random = random
  }

  variables {
    name = "badresourcegroupname."
  }

  expect_failures = [
    var.name
  ]
}

run "test_invalid_resource_group_name_greater_then_90_characters" {
  command = plan

  providers = {
    azapi  = azapi
    modtm  = modtm
    random = random
  }

  variables {
    name = "rgasdflkjsakj93jkdie9042ikojdioe03iorergasdflkjsakj93jkdie9042ikojdioe03iorergasdflkjsakj93jkdie9042ikojdioe03iore"
  }
  expect_failures = [
    var.name
  ]
}

run "test_invalid_resource_group_name_empty" {
  command = plan

  providers = {
    azapi  = azapi
    modtm  = modtm
    random = random
  }

  variables {
    name = ""
  }
  expect_failures = [
    var.name
  ]
}

run "test_invalid_resource_group_name_null" {
  command = plan

  providers = {
    azapi  = azapi
    modtm  = modtm
    random = random
  }

  variables {
    name = null
  }
  expect_failures = [
    var.name
  ]
}

run "test_lock_name_not_provided_value" {
  command = plan

  providers = {
    azapi  = azapi
    modtm  = modtm
    random = random
  }

  assert {
    condition     = azapi_resource.lock[0].name == "lock-CanNotDelete"
    error_message = "Lock name didn't match expected default value"
  }
}

run "test_lock_name_provided_value" {
  command = plan

  providers = {
    azapi  = azapi
    modtm  = modtm
    random = random
  }

  variables {
    lock = {
      kind = "CanNotDelete"
      name = "myCustomLockName"
    }
  }

  assert {
    condition     = azapi_resource.lock[0].name == var.lock.name
    error_message = "Lock name didn't match expected modified value"
  }
}

run "test_lock_kind_matches_allowed_values" {
  command = plan

  providers = {
    azapi  = azapi
    modtm  = modtm
    random = random
  }

  assert {
    condition     = contains(["CanNotDelete", "ReadOnly", "None"], var.lock.kind)
    error_message = "Lock kind didn't match expected value"
  }
}

run "test_lock_kind_validation_succeeds" {
  command = plan

  providers = {
    azapi  = azapi
    modtm  = modtm
    random = random
  }

  variables {
    lock = {
      kind = "badvalue"
    }
  }

  expect_failures = [
    var.lock.kind
  ]
}

run "test_role_assignment_role_definition_name" {
  command = plan

  providers = {
    azapi  = azapi
    modtm  = modtm
    random = random
  }

  variables {
    role_assignments = {
      "role_assignment_name_test" = {
        role_definition_id_or_name = "Reader"
        principal_id               = "a1542709-380b-49dd-bcde-a74351bc22cb"
      }
    }
  }
}

run "test_role_assignment_role_definition_id" {
  command = plan

  providers = {
    azapi  = azapi
    modtm  = modtm
    random = random
  }

  variables {
    role_assignments = {
      "role_assignment_id_test" = {
        role_definition_id_or_name = "/providers/Microsoft.Authorization/roleDefinitions/2a2b9908-6ea1-4ae2-8e65-a410df84e7d1"
        principal_id               = "a1542709-380b-49dd-bcde-a74351bc22cb"
      }
    }
  }
}

run "test_role_assignment_role_definition_id_validation_succeeds" {
  command = plan

  providers = {
    azapi  = azapi
    modtm  = modtm
    random = random
  }

  variables {
    role_assignments = {
      "role_assignment_id_test" = {
        role_definition_id_or_name = "2a2b9908-6ea1-4ae2-8e65-a410df84e7d1"
        principal_id               = "a1542709-380b-49dd-bcde-a74351bc22cb"
      }
    }
  }

  expect_failures = [
    var.role_assignments
  ]
}

run "test_ignore_tag_changes_enabled" {
  command = plan

  providers = {
    azapi  = azapi
    modtm  = modtm
    random = random
  }

  variables {
    ignore_tag_changes = true
    tags = {
      Environment = "Test"
    }
  }

  assert {
    condition     = length(azapi_resource.this) == 0
    error_message = "Expected default resource to be disabled when ignore_tag_changes is true"
  }

  assert {
    condition     = length(azapi_resource.this_ignore_tag_changes) == 1
    error_message = "Expected ignore-tag-changes resource to be enabled when ignore_tag_changes is true"
  }
}

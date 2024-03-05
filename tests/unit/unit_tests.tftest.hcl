variables {
  name = "rg-test"
  lock = {
    kind = "CanNotDelete"
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  use_cli                    = true
  environment                = startswith(var.location, "usgov") ? "usgovernment" : "public"
}

run "test_resource_group_name_validation_succeeds" {
  command = plan
  variables {
    name = "badresourcegroupname."
  }

  expect_failures = [
    var.name
  ]
}

run "test_lock_name_not_provided_value" {
  command = plan
  assert {
    condition     = azurerm_management_lock.this[0].name == "lock-rg-test"
    error_message = "Lock name didn't match expected value"
  }
}

run "test_lock_name_provided_value" {
  command = plan
  lock = {
    kind = "CanNotDelete"
    name = "myCustomLockName"
  }
  assert {
    condition     = azurerm_management_lock.this[0].name == var.lock.name
    error_message = "Lock name didn't match expected value"
  }
}


run "test_lock_kind_matches_allowed_values" {
  command = plan
  assert {
    condition     = contains(["CanNotDelete", "ReadOnly", "None"], var.lock.kind)
    error_message = "Lock name didn't match expected value"
  }
}

run "test_lock_kind_validation_succeeds" {
  command = plan
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


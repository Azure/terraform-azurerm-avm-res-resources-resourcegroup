package ecm_tester

import (
	"log"
	"os"
	"path/filepath"
	"testing"

	terraform_module_test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestIntegrationResourceGroupExists(t *testing.T) {
	dir := filepath.Join("../../", "examples")
	if _, err := os.Stat(dir); os.IsNotExist(err) {
		t.Fatalf("Directory %s does not exist", dir)
	}
	files, err := os.ReadDir(dir)
	if err != nil {

		log.Fatal(err)
	}
	for _, file := range files {
		if file.IsDir() {
			file.Info()
			t.Run(file.Name(), func(t *testing.T) {
				terraform_module_test_helper.RunE2ETest(t, "../../", filepath.Join("examples", file.Name()), terraform.Options{},
					func(t *testing.T, output terraform_module_test_helper.TerraformOutput) {
						resourceGroupName, ok := output["name"].(string)
						subscriptionID := os.Getenv("ARM_SUBSCRIPTION_ID")
						assert.True(t, ok)
						exists := azure.ResourceGroupExists(t, resourceGroupName, subscriptionID)
						assert.True(t, exists, "Resource group does not exist")
					})
			})
		}
	}
}

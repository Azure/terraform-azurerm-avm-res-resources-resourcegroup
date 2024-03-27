package ecm_tester

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"testing"

	terraform_module_test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestExample(t *testing.T) {
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
				terraform_module_test_helper.RunUnitTest(t, "../../", filepath.Join("examples", file.Name()), terraform.Options{},
					func(t *testing.T, output terraform_module_test_helper.TerraformOutput) {
						resourceGroupName, ok := output["name"].(string)
						fmt.Println("Name of the resource Group:" + resourceGroupName)
						assert.True(t, ok)
						//assert.NotEqual(t, "", resourceGroupName, "expected output `name`")
					})
			})
		}
	}

}

func TestUnitExampleTest(t *testing.T) {
	terraform_module_test_helper.RunUnitTest(t, "../../", "examples/default", terraform.Options{
		Upgrade: true,
	}, nil)
}

func TestUnitExampleTestFail(t *testing.T) {
	terraform_module_test_helper.RunUnitTest(t, "../../", "examples/default", terraform.Options{
		Upgrade: true,
	}, func(t *testing.T, output terraform_module_test_helper.TerraformOutput) {
		resourceGroupName, ok := output["name"].(string)
		fmt.Println("Name of the resource Group:" + resourceGroupName)
		fmt.Println(output["name"].(string))
		fmt.Println(output["resource"].(string))
		fmt.Println(output["resource_id"].(string))
		assert.True(t, ok)
		//assert.NotEqual(t, "", resourceGroupName, "expected output `resource_id`")
	})
}

// terraform_module_test_helper.RunE2ETest(t, "../../", filepath.Join("examples", file.Name()), terraform.Options{},
// 				func(t *testing.T, output terraform_module_test_helper.TerraformOutput) {
// 					resourceGroupName, ok := output["name"].(string)
// 					fmt.Println("Name of the resource Group:" + resourceGroupName)
// 					fmt.Println(output["name"].(string))
// 					fmt.Println(output["resource"].(string))
// 					fmt.Println(output["resource_id"].(string))
// 					assert.True(t, ok)
// 					assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/"), resourceGroupName)
// 				})

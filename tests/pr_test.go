package tests

import (
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

// Define a struct with fields that match the structure of the YAML data
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

var permanentResources map[string]interface{}

// Use existing resource group
const resourceGroup = "geretain-test-resources"
const terraformVersion = "terraform_v1.12.2" // This should match the version in the ibm_catalog.json
var validQsRegions = []string{
	"us-south",
	// Commented below regions : Refer Issue https://github.ibm.com/GoldenEye/issues/issues/17121
	// "eu-de",
	// "eu-gb",
	// "jp-tok",

	// Ignoring below regions as not supported for watsonx Assistant and watson Discovery if enabled
	// "ca-tor",
	// "us-east"
	// In watsonx-data - the plan region combination requires no KMS, hence commenting au-syd region too.
	// "au-syd",
}

func TestMain(m *testing.M) {
	// Read the YAML file contents
	var err error
	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}

	os.Exit(m.Run())
}

const quickStartDaTerraformDir = "solutions/quickstart"

func setupQuickstartOptions(t *testing.T, prefix string) *testschematic.TestSchematicOptions {

	var region = validQsRegions[common.CryptoIntn(len(validQsRegions))]
	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing:        t,
		TemplateFolder: quickStartDaTerraformDir,
		Prefix:         prefix,
		Region:         region,
		ResourceGroup:  resourceGroup,
		TarIncludePatterns: []string{
			quickStartDaTerraformDir + "/*.tf",
		},

		IgnoreDestroys: testhelper.Exemptions{ // Ignore for consistency check
			List: []string{
				"module.watsonx_ai.module.configure_user.null_resource.configure_user",
				"module.watsonx_ai.module.configure_user.null_resource.restrict_access",
			},
		},
		IgnoreUpdates: testhelper.Exemptions{ // Ignore for consistency check
			List: []string{
				"module.watsonx_ai.module.configure_user.null_resource.configure_user",
				"module.watsonx_ai.module.configure_user.null_resource.restrict_access",
			},
		},
		TerraformVersion: terraformVersion,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
		{Name: "region", Value: options.Region, DataType: "string"},
		{Name: "provider_visibility", Value: "private", DataType: "string"},
		{Name: "existing_resource_group_name", Value: resourceGroup, DataType: "string"},
	}

	return options
}

func TestRunQuickstartSolutionSchematics(t *testing.T) {
	t.Parallel()

	options := setupQuickstartOptions(t, "cnai-qs")
	err := options.RunSchematicTest()
	assert.Nil(t, err, "This should not have errored")
}

// Upgrade test for the Quickstart DA
func TestRunQuickstartUpgradeSolutionSchematics(t *testing.T) {
	t.Parallel()

	options := setupQuickstartOptions(t, "cnai-qs-upg")
	options.CheckApplyResultForUpgrade = true

	err := options.RunSchematicUpgradeTest()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
	}
}

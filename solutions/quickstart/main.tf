##############################################################################################################
# Locals Block
##############################################################################################################

locals {

  prefix = var.prefix != null ? trimspace(var.prefix) != "" ? "${var.prefix}-" : "" : ""

  # KMS
  key_ring_name = "${local.prefix}keyring"
  key_name      = "${local.prefix}key"

  # Uncomment if you would like to create a separate key for watsonx-data (if enabled)
  # wx_data_key_name = "${local.prefix}wxd-key"

  watson_plan = {
    "studio"  = "professional-v1",
    "runtime" = "v2-professional"
  }

}

##############################################################################################################
# Resource Group
##############################################################################################################

module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.4.7"
  existing_resource_group_name = var.existing_resource_group_name
}

##############################################################################
# COS
##############################################################################

module "cos" {
  source            = "terraform-ibm-modules/cos/ibm//modules/fscloud"
  version           = "10.8.1"
  resource_group_id = module.resource_group.resource_group_id
  cos_instance_name = "${local.prefix}cos"
  cos_plan          = "standard"
  cos_tags          = var.resource_tags
}

##############################################################################
# Key Protect
##############################################################################

module "key_protect_all_inclusive" {
  source                      = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version                     = "5.5.13"
  resource_group_id           = module.resource_group.resource_group_id
  region                      = var.region
  key_protect_instance_name   = "${local.prefix}kp"
  resource_tags               = var.resource_tags
  key_protect_allowed_network = "private-only"
  key_ring_endpoint_type      = "private"
  key_endpoint_type           = "private"
  keys = [
    {
      key_ring_name = local.key_ring_name
      keys = [
        {
          key_name     = local.key_name
          force_delete = true
        }
        # Uncomment if you would like to create key for watsonx.data (if enabled)
        # ,{
        #   key_name     = local.wx_data_key_name
        #   force_delete = true
        # }
      ]
    }
  ]
}

##############################################################################################################
# watsonx.ai
##############################################################################################################

data "ibm_iam_auth_token" "restapi" {}

module "watsonx_ai" {
  source            = "terraform-ibm-modules/watsonx-ai/ibm"
  version           = "2.13.2"
  region            = var.region
  resource_group_id = module.resource_group.resource_group_id
  resource_tags     = var.resource_tags
  project_name      = "${local.prefix}project-cnai"

  watsonx_ai_studio_instance_name = "${local.prefix}wx-studio"
  watsonx_ai_studio_plan          = local.watson_plan["studio"]

  watsonx_ai_runtime_instance_name = "${local.prefix}wx-runtime"
  watsonx_ai_runtime_plan          = local.watson_plan["runtime"]

  enable_cos_kms_encryption = true
  cos_instance_crn          = module.cos.cos_instance_crn
  cos_kms_key_crn           = module.key_protect_all_inclusive.keys["${local.key_ring_name}.${local.key_name}"].crn
}

##############################################################################################################
# Code Engine
##############################################################################################################

locals {

  # These are the sample application specific environment variables.
  # Please refer the sample application documentation to add/remove environment variables.
  # Reference - https://github.com/IBM/ai-agent-for-loan-risk/blob/main/artifacts/deployment/deployment-README.md
  env_vars = [{
    type      = "secret_key_reference"
    name      = "WATSONX_AI_APIKEY"
    key       = "WATSONX_AI_APIKEY"
    reference = "wx-ai"
    },
    {
      type  = "literal"
      name  = "WATSONX_SERVICE_URL"
      value = "https://${var.region}.ml.cloud.ibm.com"
    },
    {
      type  = "literal"
      name  = "WATSONX_PROJECT_ID"
      value = module.watsonx_ai.watsonx_ai_project_id
    },
    {
      type  = "literal"
      name  = "ENABLE_WXASST"
      value = "false"
    },
    {
      type  = "literal"
      name  = "WXASST_REGION"
      value = var.region
    },
    {
      type  = "literal"
      name  = "ENABLE_RAG_LLM"
      value = "false"
    }
  ]

  ce_secrets = merge(
    {
      # Secret for Watsonx
      "wx-ai" = {
        format = "generic"
        data = {
          "WATSONX_AI_APIKEY" = var.ibmcloud_api_key
        }
      }
    }
  )
  source_url  = "https://github.com/IBM/ai-agent-for-loan-risk"
  ce_app_name = "ai-agent-for-loan-risk"
}

module "code_engine" {
  source            = "terraform-ibm-modules/code-engine/ibm"
  version           = "4.7.16"
  ibmcloud_api_key  = var.ibmcloud_api_key
  resource_group_id = module.resource_group.resource_group_id
  project_name      = "${local.prefix}project"
  secrets           = local.ce_secrets
  builds = {
    "${local.prefix}ce-build" = {
      source_url                   = local.source_url
      container_registry_namespace = "cnai"
      prefix                       = var.prefix
      region                       = var.region
    }
  }
}

# Deploy the sample app on code engine
module "code_engine_app" {
  source            = "terraform-ibm-modules/code-engine/ibm//modules/app"
  version           = "4.7.16"
  project_id        = module.code_engine.project_id
  name              = local.ce_app_name
  image_reference   = module.code_engine.build["${local.prefix}ce-build"].output_image
  image_secret      = module.code_engine.build["${local.prefix}ce-build"].output_secret
  run_env_variables = local.env_vars
}


# Uncomment the following code if additional resources are needed.
# Note: the Quickstart variation does not support these resources by default but they can be enabled for extended usage.

# locals {

#   service_endpoints = "public-and-private"

#   # ICD Elastic Search
#   es_credentials = {
#     "elasticsearch_admin" : "Administrator",
#     "elasticsearch_operator" : "Operator",
#     "elasticsearch_viewer" : "Viewer",
#     "elasticsearch_editor" : "Editor",
#   }
# }

##############################################################################################################
# Watson Discovery
##############################################################################################################

# module "watson_discovery" {
#   source                = "terraform-ibm-modules/watsonx-discovery/ibm"
#   version               = "1.11.6"
#   region                = var.region
#   resource_group_id     = module.resource_group.resource_group_id
#   resource_tags         = var.resource_tags
#   plan                  = "plus"
#   watson_discovery_name = "${local.prefix}discovery"
#   service_endpoints     = local.service_endpoints
# }

# ##############################################################################################################
# # watsonx Assistant
# ##############################################################################################################

# module "watsonx_assistant" {
#   source                 = "terraform-ibm-modules/watsonx-assistant/ibm"
#   version                = "1.5.7"
#   region                 = var.region
#   resource_group_id      = module.resource_group.resource_group_id
#   resource_tags          = var.resource_tags
#   plan                   = "enterprise"
#   watsonx_assistant_name = "${local.prefix}assistant"
#   service_endpoints      = local.service_endpoints
# }

# ##############################################################################################################
# # watsonx.governance
# ##############################################################################################################

# module "watsonx_governance" {
#   source                  = "terraform-ibm-modules/watsonx-governance/ibm"
#   version                 = "1.11.6"
#   region                  = var.region
#   resource_group_id       = module.resource_group.resource_group_id
#   plan                    = "essentials"
#   watsonx_governance_name = "${local.prefix}governance"
#   resource_tags           = var.resource_tags
# }

# ##############################################################################################################
# # watsonx.data
# ##############################################################################################################

# module "watsonx_data" {
#   source                        = "terraform-ibm-modules/watsonx-data/ibm"
#   version                       = "1.12.7"
#   region                        = var.region
#   resource_group_id             = module.resource_group.resource_group_id
#   watsonx_data_name             = "${local.prefix}data"
#   plan                          = "lakehouse-enterprise"
#   use_case                      = "workloads"
#   resource_tags                 = var.resource_tags
#   enable_kms_encryption         = true
#   skip_iam_authorization_policy = false
#   watsonx_data_kms_key_crn      = module.key_protect_all_inclusive.keys["${local.key_ring_name}.${local.wx_data_key_name}"].crn
# }

# ##############################################################################################################
# # watsonx Orchestrate
# ##############################################################################################################

# module "watsonx_orchestrate" {
#   source                   = "terraform-ibm-modules/watsonx-orchestrate/ibm"
#   version                  = "1.11.6"
#   region                   = var.region
#   resource_group_id        = module.resource_group.resource_group_id
#   watsonx_orchestrate_name = "${local.prefix}orchestrate"
#   plan                     = "essentials-agentic-mau"
#   resource_tags            = var.resource_tags
# }

# ##############################################################################################################
# # Elastic search
# ##############################################################################################################

# module "icd_elasticsearch" {
#   source                   = "terraform-ibm-modules/icd-elasticsearch/ibm"
#   version                  = "2.7.1"
#   resource_group_id        = module.resource_group.resource_group_id
#   name                     = "${local.prefix}data-store"
#   region                   = var.region
#   plan                     = "enterprise"
#   elasticsearch_version    = "9.1"
#   tags                     = var.resource_tags
#   service_endpoints        = "private"
#   member_host_flavor       = "multitenant"
#   deletion_protection      = false
#   service_credential_names = local.es_credentials
# }

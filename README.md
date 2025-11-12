<!-- Update this title with a descriptive name. Use sentence case. -->
# IBM Cloud Native AI module

<!--
Update status and "latest release" badges:
  1. For the status options, see https://terraform-ibm-modules.github.io/documentation/#/badge-status
  2. Update the "latest release" badge to point to the correct module's repo. Replace "terraform-ibm-module-template" in two places.
-->
[![Graduated (Supported)](https://img.shields.io/badge/status-Graduated%20(Supported)-brightgreen?style=plastic)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-cloud-native-ai?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-cloud-native-ai/releases/latest)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

<!--
Add a description of modules in this repo.
Expand on the repo short description in the .github/settings.yml file.

For information, see "Module names and descriptions" at
https://terraform-ibm-modules.github.io/documentation/#/implementation-guidelines?id=module-names-and-descriptions
-->

The IBM Cloud Native AI Module streamlines the provisioning of essential AI and data services on IBM Cloud, enabling rapid development and deployment of enterprise-grade AI applications. It automates the setup of foundational components such as watsonx.ai for generative AI, Watson Discovery and Elasticsearch for intelligent search, watsonx.data to support open data formats and machine learning libraries for AI workloads, watsonx.governance to automate and accelerate responsible AI workflows and Code Engine for scalable runtime orchestration.

This module also provisions secure storage with IBM Cloud Object Storage, and integrates Key Protect and Secrets Manager for encryption key and secret management. Observability and compliance are built-in through Monitoring, Logs, and Security and Compliance Center.

By leveraging this module, clients can quickly establish a secure, scalable, and compliant AI landing zone tailored for Retrieval-Augmented Generation (RAG) and other advanced AI patterns


<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-cloud-native-ai](#terraform-ibm-cloud-native-ai)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->


<!-- Replace this heading with the name of the root level module (the repo name) -->
## terraform-ibm-cloud-native-ai

### Required access policies

You need the following permissions to run this module:

- Account Management
    - **Resource group**
        - `Viewer` access on the specific resource group
- IAM services
    - **watsonx.ai Runtime** service
        - `Editor` platform access
    - **watsonx.ai Studio** service
        - `Editor` platform access
    - **Watson Discovery** service
        - `Editor` platform access
    - **watsonx Assistant** service
        - `Editor` platform access
    - **watsonx.governance** service
        - `Editor` platform access
    - **watsonx.data** service
        - `Editor` platform access
    - **Database for Elasticsearch** service
        - `Editor` platform access
    - **Container Registry** service
        - `Manager` service access
    - **Code Engine** service
        - `Editor` platform access
        - `Writer` service access
    - **Cloud Object Storage** service
        - `Editor` platform access
        - `Manager` service access
    - **Key Protect** service
        - `Editor` platform access
        - `Manager` service access

> Note: If you are not the IBM Cloud account owner, then the addition of the policy `All Account Management Services` with role `Administrator` is required for storage delegation. To add the required access, go to:
`IBM Cloud -> Manage -> Access (IAM) -> Users -> {USER} -> Access -> Access Policies`



<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

No requirements.

### Modules

No modules.

### Resources

No resources.

### Inputs

No inputs.

### Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set-up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.

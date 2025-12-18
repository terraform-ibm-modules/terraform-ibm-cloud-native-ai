<!-- Update this title with a descriptive name. Use sentence case. -->
# Landing zone for Cloud Native AI applications

<!--
Update status and "latest release" badges:
  1. For the status options, see https://terraform-ibm-modules.github.io/documentation/#/badge-status
  2. Update the "latest release" badge to point to the correct module's repo. Replace "terraform-ibm-module-template" in two places.
-->
[![Stable (With quality checks)](https://img.shields.io/badge/Status-Stable%20(With%20quality%20checks)-green)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
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

The IBM Cloud Native AI Module streamlines the provisioning of essential AI and data services on IBM Cloud, enabling rapid development and deployment of enterprise-grade AI applications. It automates the setup of foundational components such as watsonx.ai for generative AI, Watson Discovery and Elasticsearch for intelligent search, watsonx.data to support open data formats and machine learning libraries for AI workloads, watsonx.governance to automate and accelerate responsible AI workflows, watsonx.Assistant or watsonx Orchestrate for conversational interfaces and Code Engine for scalable runtime orchestration.

This module also provisions secure storage with IBM Cloud Object Storage, and integrates Key Protect and Secrets Manager for encryption key and secret management. Observability and compliance are built-in through Monitoring, Logs, and Security and Compliance Center.

By leveraging this module, clients can quickly establish a secure, scalable, and compliant AI landing zone tailored for Retrieval-Augmented Generation (RAG) and other advanced AI patterns.

## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.

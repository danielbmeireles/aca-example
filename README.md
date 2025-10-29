# Azure Container App in One File <!-- omit in toc -->

![ACA example scenarios](
https://learn.microsoft.com/en-us/azure/container-apps/media/overview/azure-container-apps-example-scenarios.png)

## Table of Contents <!-- omit in toc -->

- [Description](#description)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Resources](#resources)
- [Inputs](#inputs)
- [Outputs](#outputs)


## Description

This Terraform project deploys a basic Azure Container App infrastructure running a "Hello World" application. It creates a complete container app environment including:

- Resource group for organizing Azure resources
- Log Analytics workspace for monitoring and diagnostics
- Container App environment for hosting containerized applications
- Container App running a sample quickstart image with health probes (startup, liveness, and readiness)

The deployed container app is publicly accessible via HTTPS with auto-scaling capabilities (1-3 replicas) and includes comprehensive health monitoring to ensure high availability.

---

# Terraform Configuration <!-- omit in toc -->

## Requirements

| Name                                                                      | Version |
| ------------------------------------------------------------------------- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)       | ~> 4.50 |

## Providers

| Name                                                          | Version |
| ------------------------------------------------------------- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.50 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                | Type     |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_container_app.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app)                         | resource |
| [azurerm_container_app_environment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) | resource |
| [azurerm_log_analytics_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace)     | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)                       | resource |

## Inputs

| Name                                                                | Description                          | Type          | Default                                           | Required |
| ------------------------------------------------------------------- | ------------------------------------ | ------------- | ------------------------------------------------- | :------: |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for resource naming | `string`      | `"demo"`                                          |    no    |
| <a name="input_location"></a> [location](#input\_location)          | Azure region for resources           | `string`      | `"West Europe"`                                   |    no    |
| <a name="input_project"></a> [project](#input\_project)             | Project name for resource naming     | `string`      | `"containerapp"`                                  |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                      | Tags to apply to resources           | `map(string)` | <pre>{<br/>  "ManagedBy": "Terraform"<br/>}</pre> |    no    |

## Outputs

| Name                                                                                              | Description                                      |
| ------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| <a name="output_container_app_fqdn"></a> [container\_app\_fqdn](#output\_container\_app\_fqdn)    | Fully qualified domain name of the Container App |
| <a name="output_container_app_name"></a> [container\_app\_name](#output\_container\_app\_name)    | Name of the Container App                        |
| <a name="output_container_app_url"></a> [container\_app\_url](#output\_container\_app\_url)       | URL to access the Container App                  |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group                       |

---

Made with 💙 with [Terraform](https://www.terraform.io/) and [VS Code](https://code.visualstudio.com/)

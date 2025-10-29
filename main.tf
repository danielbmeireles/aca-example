terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.50"
    }
  }
}

provider "azurerm" {
  features {} 
}

# Variables for customization
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "West Europe"
}

variable "project" {
  description = "Project name for resource naming"
  type        = string
  default     = "containerapp"
}

variable "environment" {
  description = "Environment name for resource naming"
  type        = string
  default     = "demo"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.location

  tags = merge(
    var.tags,
    {
      Environment = title(var.environment)
    }
  )
}

# Log Analytics Workspace (required for Container App Environment)
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.project}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = merge(
    var.tags,
    {
      Environment = title(var.environment)
    }
  )
}

# Container App Environment
resource "azurerm_container_app_environment" "main" {
  name                       = "cae-${var.project}-${var.environment}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  tags = merge(
    var.tags,
    {
      Environment = title(var.environment)
    }
  )
}

# Container App - Simple Hello World
resource "azurerm_container_app" "main" {
  name                         = "ca-${var.project}-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    max_replicas = 3

    container {
      name   = "hello-world"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      # Startup Probe - checks if container has started successfully
      # Runs only at startup, before other probes begin
      startup_probe {
        transport               = "HTTP"
        port                    = 80
        path                    = "/"
        interval_seconds        = 5
        timeout                 = 3
        failure_count_threshold = 3
        initial_delay           = 0
      }

      # Liveness Probe - checks if container is alive
      # If it fails, the container will be restarted
      liveness_probe {
        transport               = "HTTP"
        port                    = 80
        path                    = "/"
        interval_seconds        = 30
        timeout                 = 5
        failure_count_threshold = 3
        initial_delay           = 10
      }

      # Readiness Probe - checks if container is ready to receive traffic
      # If it fails, container is temporarily removed from load balancer
      readiness_probe {
        transport               = "HTTP"
        port                    = 80
        path                    = "/"
        interval_seconds        = 10
        timeout                 = 3
        failure_count_threshold = 3
        success_count_threshold = 1
        initial_delay           = 5
      }
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80
    transport                  = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  tags = merge(
    var.tags,
    {
      Environment = title(var.environment)
      Application = "HelloWorld"
    }
  )
}

# Outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "container_app_fqdn" {
  description = "Fully qualified domain name of the Container App"
  value       = azurerm_container_app.main.latest_revision_fqdn
}

output "container_app_url" {
  description = "URL to access the Container App"
  value       = "https://${azurerm_container_app.main.latest_revision_fqdn}"
}

output "container_app_name" {
  description = "Name of the Container App"
  value       = azurerm_container_app.main.name
}

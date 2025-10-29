#!/bin/bash
echo "=== Checking Azure Login ==="
az account show || { echo "Failed: Please run 'az login' first"; exit 1; }

echo "=== Setting environment variables ==="
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
export ARM_TENANT_ID=$(az account show --query tenantId -o tsv)

echo "Subscription ID: $ARM_SUBSCRIPTION_ID"
echo "Tenant ID: $ARM_TENANT_ID"

echo "=== Planning the infrastructure ==="
terraform plan

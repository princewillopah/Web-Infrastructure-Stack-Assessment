# Azure Web Infrastructure Deployment

This repository contains Terraform configuration files to provision a web infrastructure stack on Azure. The stack includes a virtual network, subnets, NSGs, VMs, load balancer, application gateway, and an Azure SQL Database.

## Prerequisites

- Terraform installed on your local machine
- Azure CLI installed and authenticated
- A valid Azure subscription

## Project Structure

- **main.tf**: Defines the resources for the infrastructure.
- **variables.tf**: Contains all the variable definitions used in `main.tf`.
- **outputs.tf**: Specifies the output values to be displayed after the infrastructure is provisioned.

**Note:** The `provider.tf` and `terraform.tfvars` files, which hold the credentials and configuration to connect to Azure, are not included in this repository. These files should be created locally with your specific credentials and configuration.

## Example `provider.tf`

Below is an example of a `provider.tf` file using dummy credentials. Replace the placeholders with your actual Azure credentials.

```hcl
provider "azurerm" {
  features = {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = "your-subscription-id"
  client_id       = "your-client-id"
  client_secret   = "your-client-secret"
  tenant_id       = "your-tenant-id"
}
```

## Example terraform.tfvars

```hcl
location              = "East US"
resource_group_name   = "my-resource-group"
vnet_address_space    = "10.0.0.0/16"
web_tier_subnet       = "10.0.1.0/24"
db_tier_subnet        = "10.0.2.0/24"
api_gateway_subnet    = "10.0.3.0/24"  # neccessary for best practice
tags                  = {
  environment = "production"
  owner       = "your-name"
}
admin_u               = "your-admin-username"
admin_pw              = "your-admin-password"


```


## Steps to Deploy

1. Clone the repository:
   ```
   git clone https://github.com/princewillopah/Web-Infrastructure-Stack-Assessment
   cd Web-Infrastructure-Stack-Assessment
   ```

2. Initialize Terraform:
   ```
   terraform init
   ```

3. Review the configuration and make any necessary changes.

4. Apply the configuration:
   ```
   terraform apply
   ```

5. Follow the prompts to confirm the infrastructure deployment.

## Components Deployed

- **Virtual Network**: A VNet with address space 10.0.0.0/16
- **Subnets**: Web tier, database tier and api gateway subnets
- **NSGs**: Security groups for web and database tiers
- **Virtual Machines**: 2 web VMs and 1 database VM
- **Azure Load Balancer**: A load balancer with an HTTP health probe
- **Azure Application Gateway**: Configured for HTTP traffic
- **Azure SQL Database**: Provisioned with standard pricing tier
- **Azure Key Vault**: Storing secrets like the database connection string
- **Azure Backup**: Configured to back up VMs
- **Azure Security Center**: Monitoring and managing security

## Cleanup

To destroy the infrastructure:

```
   terraform destroy
```

## Due to some unforseening constraints and other factors, i could not transform the working code modules within my timeframes. 
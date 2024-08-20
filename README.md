# Azure Web Infrastructure Deployment

This repository contains Terraform configuration files to provision a web infrastructure stack on Azure. The stack includes a virtual network, subnets, NSGs, VMs, load balancer, application gateway, and an Azure SQL Database.

## Prerequisites

- Terraform installed on your local machine
- Azure CLI installed and authenticated
- A valid Azure subscription

## Steps to Deploy

1. Clone the repository:
   ```
   git clone https://github.com/your-username/azure-web-infrastructure.git
   cd azure-web-infrastructure
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
- **Subnets**: Web tier and database tier subnets
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
```# Web-Infrastructure-Stack-Assessment

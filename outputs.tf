# # Output the Resource Group name
# output "resource_group_name" {
#   value = azurerm_resource_group.RG.name
#   description = "The name of the Azure Resource Group."
# }

# # Output the Virtual Network ID
# output "virtual_network_id" {
#   value = azurerm_virtual_network.main-vnet.id
#   description = "The ID of the Azure Virtual Network."
# }

# # Output the Web Tier Subnet ID
# output "web_tier_subnet_id" {
#   value = azurerm_subnet.web-tier-subnet.id
#   description = "The ID of the Web Tier Subnet."
# }

# # Output the Database Tier Subnet ID
# output "db_tier_subnet_id" {
#   value = azurerm_subnet.db-tier-subnet.id
#   description = "The ID of the Database Tier Subnet."
# }

# # Output the Web Tier Network Security Group ID
# output "web_nsg_id" {
#   value = azurerm_network_security_group.web_nsg.id
#   description = "The ID of the Web Tier Network Security Group."
# }

# # Output the Database Tier Network Security Group ID
# output "db_nsg_id" {
#   value = azurerm_network_security_group.db_nsg.id
#   description = "The ID of the Database Tier Network Security Group."
# }

# # Output the Public IP addresses for Web Tier VMs
# output "web_public_ips" {
#   value = azurerm_public_ip.web_public_ip[*].ip_address
#   description = "The public IP addresses assigned to the Web Tier VMs."
# }

# # Output the Network Interface IDs for Web Tier VMs
# output "web_nic_ids" {
#   value = azurerm_network_interface.web_tier_nic[*].id
#   description = "The Network Interface IDs for the Web Tier VMs."
# }

# # Output the Availability Set ID
# output "availability_set_id" {
#   value = azurerm_availability_set.web_avail_set.id
#   description = "The ID of the Availability Set for Web Tier VMs."
# }

# # Output the Web Tier VM IDs
# output "web_vm_ids" {
#   value = azurerm_windows_virtual_machine.web_tier_vm[*].id
#   description = "The IDs of the Web Tier Virtual Machines."
# }

# # Output the Database VM ID
# output "db_vm_id" {
#   value = azurerm_windows_virtual_machine.db_tier_vm.id
#   description = "The ID of the Database Virtual Machine."
# }

# # Output the Load Balancer Public IP
# output "lb_public_ip" {
#   value = azurerm_public_ip.web_lb_public_ip.ip_address
#   description = "The public IP address of the Load Balancer."
# }

# # Output the Application Gateway Public IP
# output "app_gateway_public_ip" {
#   value = azurerm_public_ip.app_gateway_public_ip.ip_address
#   description = "The public IP address of the Application Gateway."
# }

# # Output the SQL Server Fully Qualified Domain Name (FQDN)
# output "sql_server_fqdn" {
#   value = azurerm_sql_server.sql_server.fully_qualified_domain_name
#   description = "The fully qualified domain name of the SQL Server."
# }

# # Output the SQL Database Connection String
# output "sql_database_connection_string" {
#   value = azurerm_key_vault_secret.sql_database_connection_string.value
#   description = "The connection string for the SQL Database."
# }

# # Output the Recovery Services Vault Name
# output "recovery_services_vault_name" {
#   value = azurerm_recovery_services_vault.key_vault_backup.name
#   description = "The name of the Recovery Services Vault."
# }

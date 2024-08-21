# Resource Group
resource "azurerm_resource_group" "RG" {
  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "main-vnet" {
  name                = "infra-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}

# Web Tier Subnet
resource "azurerm_subnet" "web-tier-subnet" {
  name                 = "web-tier-subnet"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.main-vnet.name
  address_prefixes     = [var.web_tier_subnet]
}

# Database Tier Subnet
resource "azurerm_subnet" "db-tier-subnet" {
  name                 = "db-tier-subnet"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.main-vnet.name
  address_prefixes     = [var.db_tier_subnet]
}



# NSGs

# Web Tier NSG
resource "azurerm_network_security_group" "web_nsg" {
  name                = "web-tier-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name

  security_rule {
    name                       = "Allow_HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_HTTPS"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Database Tier NSG
resource "azurerm_network_security_group" "db_nsg" {
  name                = "db-tier-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name

  security_rule {
    name                       = "Allow_SQL_From_Web"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = azurerm_subnet.web-tier-subnet.address_prefixes[0]  # "10.0.1.0/24"
    destination_address_prefix = "*"
  }
}


# ---------------------------
## Virtual Machines
# ---------------------------
resource "azurerm_public_ip" "web_public_ip" {
  count               = 2
  name                = "web-public-ip-${count.index + 1}"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name
  allocation_method   = "Static"
}


# Network Interface for Web-Tiers VMs
resource "azurerm_network_interface" "web_tier_nic" {
  count               = 2
  name                = "web-nic-${count.index+1}"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web-tier-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_public_ip[count.index].id
  }
}

# Network Interface for Database VM
resource "azurerm_network_interface" "db_nic" {
  name                      = "db-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.db-tier-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# availability set
resource "azurerm_availability_set" "web_avail_set" {
  name                         = "web-avail-set"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.RG.name
  managed                      = true
}

# web_tier VM
resource "azurerm_windows_virtual_machine" "web_tier_vm" {
  count                        = 2
  name                         = "web-vm-${count.index+1}"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.RG.name
  availability_set_id          = azurerm_availability_set.web_avail_set.id
  size                         = "Standard_D2s_v3"
  admin_username                = "adminuser" ## var.admin_u
  admin_password                = "P@ssword123!" ## var.admin_pw
  network_interface_ids        = [azurerm_network_interface.web_tier_nic[count.index].id]

  os_disk {
    caching                     = "ReadWrite"
    storage_account_type        = "Standard_LRS"
    disk_size_gb                = 128
  }

  source_image_reference {
    publisher                   = "MicrosoftWindowsServer"
    offer                       = "WindowsServer"
    sku                         = "2019-Datacenter"
    version                     = "latest"
  }
}

## DB tier vm
resource "azurerm_windows_virtual_machine" "db_tier_vm" {
  name                         = "db-vm"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.RG.name
  network_interface_ids        = [azurerm_network_interface.db_nic.id]
  size                         = "Standard_D4s_v3"
  admin_username               = "adminuser" ## var.admin_u
  admin_password               = "P@ssword123!" ## var.admin_pw

  os_disk {
    caching                     = "ReadWrite"
    storage_account_type        = "Premium_LRS"
    disk_size_gb                = 256
  }
  source_image_reference {
    publisher                   = "MicrosoftWindowsServer"
    offer                       = "WindowsServer"
    sku                         = "2019-Datacenter"
    version                     = "latest"
  }
}


## ----------------------------------
## Load Balancer
## -------------------------------------

resource "azurerm_public_ip" "web_lb_public_ip" {
  name                = "lb-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name
  allocation_method   = "Static"
}


## LB
resource "azurerm_lb" "vm-lb" {
  name                = "vm-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.web_lb_public_ip.id
  }
}


# Backend Address Pool for Azure Load Balancer
resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  name                = "lb-backend-pool"
  loadbalancer_id     = azurerm_lb.vm-lb.id
}

# HTTP Probe for Load Balancer
resource "azurerm_lb_probe" "lb_http_probe" {
  name                = "http-probe"
  loadbalancer_id     = azurerm_lb.vm-lb.id
  protocol            = "Http"
  request_path        = "/"
  port                = 80
  interval_in_seconds = 10
  number_of_probes    = 2
}

# Create a Load Balancing Rule
resource "azurerm_lb_rule" "lb_rules" {
  name                = "lb-http-rules"
  loadbalancer_id     = azurerm_lb.vm-lb.id
  frontend_ip_configuration_name = azurerm_lb.vm-lb.frontend_ip_configuration[0].name
  protocol            = "Tcp"
  frontend_port       = 80
  backend_port        = 80
  # backend_address_pool_id = [azurerm_lb_backend_address_pool.lb_backend_pool.id]
  probe_id            = azurerm_lb_probe.lb_http_probe.id
}


# Associate the VM with the Load Balancer
resource "azurerm_network_interface_backend_address_pool_association" "lb_vm_and_vm_assoc" {
  count                   = 2
  network_interface_id = azurerm_network_interface.web_tier_nic[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
}

### ---------------------------
### Azure Application Gateway
### ---------------------------
resource "azurerm_public_ip" "app_gateway_public_ip" {
  name                = "api-gateway-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "app_gateway" {
  name                = "app-gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    # capacity = 2
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 5
  }

  gateway_ip_configuration {
    name                  = "app_gateway_ip_configuration"
    subnet_id             = azurerm_subnet.web-tier-subnet.id
  }

  frontend_ip_configuration {
    name                 = "frontend_ip_configuration"
    public_ip_address_id = azurerm_public_ip.app_gateway_public_ip.id
  }

  backend_http_settings {
    name                  = "http_settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  frontend_port {
    name = "api-gateway-frontend-port"
    port = 80
  }

  backend_address_pool {
    name = "api-gateway-backend"
  }

  http_listener {
    name                           = "api-gateway-listener"
    frontend_ip_configuration_name = "frontend_ip_configuration"
    frontend_port_name             = "api-gateway-frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "request_routing_rule"
    rule_type                  = "Basic"
    http_listener_name         = "api-gateway-listener"
    backend_address_pool_name  = "api-gateway-backend"
    backend_http_settings_name = "http_settings"
     priority                   = 100
  }

}
 
# # Associate VMs with API Gateway Backend Pool
# resource "azurerm_application_gateway_backend_address_pool" "api_gateway_backend_pool" {
#   name                = azurerm_application_gateway.app_gateway.backend_address_pool[0].name
#   application_gateway_name = azurerm_application_gateway.app_gateway.name
#   resource_group_name = azurerm_resource_group.RG.name

#   ip_addresses = [azurerm_network_interface.web_tier_nic[0].private_ip_address, azurerm_network_interface.web_tier_nic[1].private_ip_address]
# }


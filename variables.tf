
variable "location" {
  type        = string
  default     = "West US"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  default     = "Princewill--Web-Infrastructure-Stack-Assessment-RG"
  description = " Resource for the infrastructure"
}


variable "tags" {
  description = "Map of the tags to use for the resources that are deployed"
  type        = map(string)
  default = {
    environment = "QA"
  }
}

variable "vnet_address_space" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Address Space for VNET"
}

variable "web_tier_subnet" {
  type        = string
  default     = "10.0.1.0/24"
  description = "Address prefix for web tier subnet"
}

variable "db_tier_subnet" {
  type        = string
  default     = "10.0.2.0/24"
  description = "Address prefix for DB tier subnet"
}
variable "api_gateway_subnet" {
  type        = string
  default     = "10.0.3.0/24"
  description = "Address prefix for app gateway subnet"
}
variable "admin_u" {
  type        = string
  description = "Admin username for VM."
}

variable "admin_pw" {
  type        = string
  description = "Admin password for VM."
}

variable "administrator_login" {
  type        = string
  description = "Admin username for SQL."
}

variable "administrator_login_pw" {
  type        = string
  description = "Admin password for SQL."
}






# variable "application_port" {
#   description = "Port that you want to expose to the external load balancer"
#   default     = 80
# }

# variable "admin_user" {
#   description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
#   default     = "azureuser"
# }

# variable "admin_password" {
#   description = "Default password for admin account"
#   default     = "ChangeMe123!"
#   sensitive   = true
# }
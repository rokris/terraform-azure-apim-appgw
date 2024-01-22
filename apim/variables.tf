variable "dns_zone" {
  default = "azure-api.net"
}

variable "apim_name" {
  default = "ng-ti-test-rokris-apim"
}

variable "location" {
  default = "Norway East"
}

variable "apim_rg" {
  default = "ng-ti-test-rokris-rg"
}

variable "vnet_name" {
  default = "ng-ti-test-rokris-vnet"
}

variable "apim_subnet_name" {
  default = "ng-ti-test-rokris-apim-1-snet"
}

variable "apim_nsg_name" {
  default = "ng-ti-test-rokris-apim-nsg"
}

variable "apim_subnet_iprange" {
  default = "10.96.10.16/28"
}

variable "apim_subnet_service_endpoints" {
  default = "Microsoft.KeyVault"  
}

variable "apim_pip_name" {
  default = "ng-ti-test-rokris-apim-pip"
}

variable "tags" {
  default = {
    owner       = "Roger Kristiansen"
    environment = "Lab"
  }
}

variable "keyvault" {
  default = "ng-ti-test-rokris-kv"
}

variable "certificate_name" {
  default = "star-snorkelground"
}

variable "sku" {
  default = "Developer_1"
}

variable "publisher_email" {
  default = "roger.kristiansen@norgesgruppen.no"
}

variable "publisher_name" {
  default = "NorgesGruppen Data AS"
}

variable "gateway_dns_name" {
  default = "api.snorkelground.no"
}

variable "developer_portal_dns_name" {
  default = "portal.snorkelground.no"
}

variable "management_dns_name" {
  default = "management.snorkelground.no"
}

variable "nsg_rules" {
  type = map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_address_prefix      = string
    source_port_range          = string
    destination_address_prefix = string
    destination_port_range     = string
  }))
  default = {
    inbound-http = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    inbound-https = {
      priority                   = 105
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    inbound-management = {
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    inbound-azure-lb = {
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "6390"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureLoadBalancer"
    }
    outbound-storage = {
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    }
    outbound-sql = {
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1433"
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    }
    outbound-key-vault = {
      priority                   = 120
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    }
  }
}

variable "nat_pip_name" {
  default = "ng-ti-test-rokris-nat-pip"
}

variable "nat_gw_name" {
  default = "ng-ti-test-rokris-nat"
}

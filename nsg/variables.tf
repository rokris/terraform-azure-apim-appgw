variable "location" {
    default = "Norway East"
}

variable "apim_rg" {
    default = "ng-ti-test-rokris-rg"
}

variable "apim_nsg_name" {
    default = "ng-ti-test-rokris-apim-nsg"
}

variable "tags" {
    default = {
        owner = "Roger Kristiansen"
        environment = "Lab"
  }
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
      priority                    = 100
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "80"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    }
    inbound-https = {
      priority                    = 105
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "443"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    }
    inbound-management = {
      priority                    = 110
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "3443"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    }
    inbound-azure-lb = {
      priority                    = 120
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "6390"
      source_address_prefix       = "*"
      destination_address_prefix  = "AzureLoadBalancer"
    }
    outbound-storage = {
      priority                    = 100
      direction                   = "Outbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "443"
      source_address_prefix       = "*"
      destination_address_prefix  = "VirtualNetwork"
    }
    outbound-sql = {
      priority                    = 110
      direction                   = "Outbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "1433"
      source_address_prefix       = "*"
      destination_address_prefix  = "VirtualNetwork"
    }
    outbound-key-vault = {
      priority                    = 120
      direction                   = "Outbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "443"
      source_address_prefix       = "*"
      destination_address_prefix  = "VirtualNetwork"
    }
  }
}


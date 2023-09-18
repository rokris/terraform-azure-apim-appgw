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

variable "apim_pip_name" {
  default = "ng-ti-test-rokris-apim-pip"
}

variable "tags" {
    default = {
        owner = "Roger Kristiansen"
        environment = "Lab"
  }
}

variable "keyvault" {
  default = "ng-ti-test-rokris-kv"
}

variable "certificate_name" {
  default = "star-snorkelground"
}

variable "dns_zone" {
    default = "snorkelground.no"
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

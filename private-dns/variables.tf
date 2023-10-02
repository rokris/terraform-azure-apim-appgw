variable "private_dns_rg" {
  default = "ng-ti-test-rokris-rg"
}

variable "vnet_name" {
  default = "ng-ti-test-rokris-vnet"
}

variable "tags" {
  default = {
    owner       = "Roger Kristiansen"
    environment = "Lab"
  }
}

variable "dns_zone" {
  default = "snorkelground.com"
}

variable "apim_name" {
  default = "ng-ti-test-rokris-apim"
}
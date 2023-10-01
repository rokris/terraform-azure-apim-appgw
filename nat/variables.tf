variable "location" {
  default = "Norway East"
}

variable "nat_rg_name" {
  default = "ng-ti-test-rokris-rg"
}

variable "tags" {
  default = {
    owner       = "Roger Kristiansen"
    environment = "Lab"
  }
}

variable "vnet_name" {
  default = "ng-ti-test-rokris-vnet"
}

variable "nat_subnet_name" {
  default = "ng-ti-test-rokris-nat-snet"
}

variable "nat_subnet_iprange" {
  default = "10.96.10.96/28"
}

variable "nat_pip_name" {
  default = "ng-ti-test-rokris-nat-pip"
}

variable "nat_gw_name" {
  default = "ng-ti-test-rokris-nat"
}

variable "apim_snet_name" {
  default = "ng-ti-test-rokris-apim-1-snet"
}

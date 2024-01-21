variable "waf_policy_name" {
  default = "ng-ti-test-rokris-waf"
}

variable "location" {
  default = "Norway East"
}

variable "waf_policy_rg" {
  default = "ng-ti-test-rokris-rg"
}

variable "tags" {
  default = {
    owner       = "Roger Kristiansen"
    environment = "Lab"
  }
}
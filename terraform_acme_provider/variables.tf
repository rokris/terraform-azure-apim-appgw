variable "resource_group_name" {
  default = "ng-ti-test-rokris-rg"
}

variable "key_vault" {
  default = "ng-ti-test-rokris-kv"
}

variable "tags" {
  default = {
    owner       = "Roger Kristiansen"
    environment = "Lab"
  }
}

variable "email_address" {
  default = "roger.kristiansen@norgesgruppen.no"
}

variable "cert_name" {
  default = "star-snorkelground"
}

variable "cert_cn" {
  default = "*.snorkelground.com"
}

variable "cert_sub" {
  default = ""
}

variable "cert_algorithm" {
  default = "RSA"
}

variable "cert_bits" {
  default = 2048
}
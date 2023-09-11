variable "DOMENESHOP_API_TOKEN" {
  description = "This must be set in terraform.tfvars file"
  default = ""
}

variable "DOMENESHOP_API_SECRET" {
  description = "This must be set in terraform.tfvars file"
  default = ""
}

variable "resource_group_name" {
  default = "ng-ti-test-rokris-rg"
}

variable "key_vault" {
  default = "ng-ti-test-rokris-kv"
}

variable "tags" {
  default = {
    owner = "Roger Kristiansen"
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
  default = "*.snorkelground.no"
}

variable "cert_sub" {
  default = "*.snorkelground.no, *.snorkelground.com"
}

variable "cert_algorithm" {
  default = "RSA"
}

variable "cert_bits" {
  default = 2048
}
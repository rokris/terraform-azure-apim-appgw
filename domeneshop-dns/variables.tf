# variable "domeneshop_domain" {
#   type = object({
#     id     = string
#     domain = string
#   })
#   description = "The Domeneshop zone to add the records to."
# }

# variable "recordsets" {
#   type = set(object({
#     name    = string
#     type    = string
#     ttl     = number
#     records = set(string)
#   }))
#   description = "Set of DNS record objects to manage, in the standard terraformdns structure."
# }

variable "DOMENESHOP_API_TOKEN" {
  type      = string
  sensitive = true
}

variable "DOMENESHOP_API_SECRET" {
  type      = string
  sensitive = true
}

variable "domain" {
  type      = string
  default   = null
}

variable "appgw_pip_name" {
  default = "ng-ti-test-rokris-agw-pip"
}

variable "resource_group_name" {
  default = "ng-ti-test-rokris-rg"
}

variable "appgw_rg" {
  default = "ng-ti-test-rokris-rg"
}

variable "appgw_name" {
  default = "ng-ti-test-rokris-agw"
}

variable "location" {
  default = "Norway East"
}

variable "tags" {
  default = {
    owner       = "Roger Kristiansen"
    environment = "Lab"
  }
}

variable "domain" {
  type    = string
  default = "snorkelground.com"
}

variable "vnet_name" {
  default = "ng-ti-test-rokris-vnet"
}

variable "keyvault" {
  default = "ng-ti-test-rokris-kv"
}

variable "apim_gateway_dns_name" {
  default = "api.azure-api.net"
}

variable "certificate_name" {
  default = "star-snorkelground"
}

variable "user_assigned_identity_name" {
  default = "ng-ti-test-rokris-appgw-mi"
}

variable "enable_http2" {
  description = "Enable HTTP2"
  type        = bool
  default     = true
}

variable "appgw_subnet_name" {
  default = "ng-ti-test-rokris-agw-snet"
}

variable "appgw_subnet_iprange" {
  default = "10.96.10.64/28"
}

variable "frontend_port_name" {
  default = "myFrontendPort"
}

variable "frontend_ip_configuration_name" {
  default = "myAGIPConfig"
}

variable "appgw_pip_name" {
  default = "ng-ti-test-rokris-agw-pip"
}

variable "backend_address_pool_name" {
  default = "ApimPool"
}

variable "https_setting_name" {
  default = "myHTTPSsetting"
}

variable "listener_name" {
  default = "myListenerHttps"
}

variable "probe_name" {
  default = "test_probe"
}

variable "probe_apim_gateway_dns_name" {
  default = "api.snorkelground.com"
}

variable "gateway_ip_config_name" {
  default = "my-gateway-ip-configuration"
}

variable "request_routing_rule_name" {
  default = "myRoutingRule"
}

variable "firewall_policy_id" {
  description = "ID of a Web Application Firewall Policy"
  type        = string
  default     = null
}

variable "sku" {
  description = "The Name of the SKU to use for this Application Gateway. Possible values are Standard_v2 and WAF_v2."
  type        = string
  default     = "WAF_v2"
}
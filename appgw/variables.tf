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
    owner = "Roger Kristiansen"
    environment = "Lab"
  }
}

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

variable "vnet_name" {
  default = "ng-ti-test-rokris-vnet"
}

variable "keyvault" {
  default = "ng-ti-test-rokris-kv"
}

variable "apim_gateway_dns_name" {
  default = "api.snorkelground.com"
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

variable "frontend_subnet_name" {
  default = "ng-ti-test-rokris-frontend-agw-snet"
}

variable "frontend_subnet_iprange" {
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

variable "backend_subnet_name" {
  default = "ng-ti-test-rokris-backend-agw-snet"
}

variable "backend_subnet_iprange" {
  default = "10.96.10.80/28"
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

### WAF

variable "force_firewall_policy_association" {
  description = "Enable if the Firewall Policy is associated with the Application Gateway."
  type        = bool
  default     = false
}

variable "waf_configuration" {
  description = <<EOD
WAF configuration object (only available with WAF_v2 SKU) with following attributes:
```
- enabled:                  Boolean to enable WAF.
- file_upload_limit_mb:     The File Upload Limit in MB. Accepted values are in the range 1MB to 500MB.
- firewall_mode:            The Web Application Firewall Mode. Possible values are Detection and Prevention.
- max_request_body_size_kb: The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB.
- request_body_check:       Is Request Body Inspection enabled ?
- rule_set_type:            The Type of the Rule Set used for this Web Application Firewall.
- rule_set_version:         The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, and 3.1.
- disabled_rule_group:      The rule group where specific rules should be disabled. Accepted values can be found here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#rule_group_name
- exclusion:                WAF exclusion rules to exclude header, cookie or GET argument. More informations on: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#match_variable
```
EOD
  type = object({
    enabled                  = optional(bool, true)
    file_upload_limit_mb     = optional(number, 100)
    firewall_mode            = optional(string, "Prevention")
    max_request_body_size_kb = optional(number, 128)
    request_body_check       = optional(bool, true)
    rule_set_type            = optional(string, "OWASP")
    rule_set_version         = optional(string, 3.2)
    disabled_rule_group      = optional(list(object({
      rule_group_name        = string
      rules                  = optional(list(string))
    })), [])
    exclusion = optional(list(object({
      match_variable          = string
      selector                = optional(string)
      selector_match_operator = optional(string)
    })), [])
  })
  default = {}
}

variable "disable_waf_rules_for_dev_portal" {
  description = "Whether to disable some WAF rules if the APIM developer portal is hosted behind this Application Gateway. See locals.tf for the documentation link."
  type        = bool
  default     = true
}
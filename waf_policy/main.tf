resource "azurerm_web_application_firewall_policy" "main" {
    location            = var.location
    name                = var.waf_policy_name
    resource_group_name = var.waf_policy_rg
    tags                = var.tags

    managed_rules {
        managed_rule_set {
            type    = "OWASP"
            version = "3.2"

            rule_group_override {
                rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"

                rule {
                    action  = "AnomalyScoring"
                    enabled = false
                    id      = "942100"
                }
                rule {
                    action  = "AnomalyScoring"
                    enabled = false
                    id      = "942200"
                }
                rule {
                    action  = "AnomalyScoring"
                    enabled = false
                    id      = "942110"
                }
                rule {
                    action  = "AnomalyScoring"
                    enabled = false
                    id      = "942180"
                }
                rule {
                    action  = "AnomalyScoring"
                    enabled = false
                    id      = "942260"
                }
                rule {
                    action  = "AnomalyScoring"
                    enabled = false
                    id      = "942340"
                }
                rule {
                    action  = "AnomalyScoring"
                    enabled = false
                    id      = "942370"
                }
                rule {
                    action  = "AnomalyScoring"
                    enabled = false
                    id      = "942430"
                }
                rule {
                    action  = "AnomalyScoring"
                    enabled = false
                    id      = "942440"
                }
            }
            rule_group_override {
                rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"

                rule {
                    action  = "AnomalyScoring"
                    enabled = false
                    id      = "920300"
                }
                rule {
                    action  = "AnomalyScoring"
                    enabled = false
                    id      = "920330"
                }
            }
            rule_group_override {
                rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"

                rule {
                    action  = "AnomalyScoring"
                    enabled = false
                    id      = "931130"
                }
            }
        }
        managed_rule_set {
            type    = "Microsoft_BotManagerRuleSet"
            version = "1.0"
        }
    }

    policy_settings {
        enabled                          = true
        file_upload_limit_in_mb          = 100
        max_request_body_size_in_kb      = 128
        mode                             = "Prevention"
        request_body_check               = true
        request_body_inspect_limit_in_kb = 128
    }
}
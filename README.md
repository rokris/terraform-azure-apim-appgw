# terraform-azure-apim-appgw
## Deploy DNS Private zone, Azure API Management, Azure App Gateway
[![infracost](https://img.shields.io/endpoint?url=https://dashboard.api.infracost.io/shields/json/9775c3c0-30e0-4a7b-872e-34be9cce38f2/repos/1a8537db-dda5-4531-bda2-f0a757744edf/branch/f62d9988-dd0e-4410-b167-eb91ce32f50b)](https://dashboard.infracost.io/org/rokris/repos/1a8537db-dda5-4531-bda2-f0a757744edf?tab=settings)

![Azure APIM architecture](https://github.com/rokris/terraform-azure-apim-appgw/assets/18302354/145eaec1-94b1-4c38-a2c3-89b606364b4f)


- Edit variables.tf files according to your environment
- Login (az login)
- az account set --subscription \<subscription>
- terraform init (optional: -upgrade)
- terraform plan (optional: -out tfplan)
- terraform apply (optional: tfplan)
- terraform destroy (optional: -auto-approve)

The running sequence of terraform deployments
---
Group 1
- Module terraform_acme_provider
- Module waf_policy

Group 2
- Module apim

Group 3
- Module appgw
---
### Alternativ deployment with use of Terragrunt
- terragrunt run-all init -upgrade
- terragrunt run-all plan -out tfplan --terragrunt-non-interactive --terragrunt-ignore-dependency-errors
- terragrunt run-all apply tfplan --terragrunt-non-interactive --terragrunt-ignore-dependency-errors
- terragrunt run-all destroy --terragrunt-non-interactive --terragrunt-ignore-dependency-errors

## Requirements
- Resourcegroup exist in Azure subscription
- Azure Vnet exist in Azure subscription
- Azure Key Vault exist in Azure subscription
    - secret: domeneshop-api-token
    - secret: domeneshop-api-secret
- Storage account exist in Azure subscription
- AZ CLI
- Terraform installed
- Terrgrunt installed

## FinOps with Infracost
https://www.infracost.io/docs/

```shell
brew install infracost
infracost auth login
infracost configure get api_key
export INFRACOST_CURRENCY_FORMAT="NOK: 1.234,56 kr"
infracost breakdown --path=. 
```

---

## Work is still in progress

# terraform-azure-apim-appgw
## Deploy DNS Private zone, Azure API Management, Azure App Gateway

![image](https://github.com/rokris/terraform-azure-apim-appgw/assets/18302354/0f564774-ce3b-4f67-9331-b1a50affba77)

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
- Module private-dns

Group 4
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

```bash
brew install infracost \
infracost auth login \
infracost configure get api_key \
infracost breakdown --path=. 
```
---

## Work is still in progress

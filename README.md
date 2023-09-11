# terraform-azure-apim-appgw
## Deploy DNS Private zone, Azure API Management, Azure App Gateway

- Login (az login)
- az account set --subscription ng-ti-sandbox
- terraform init (optional: -upgrade)
- terraform plan (optional: -out tfplan)
- terraform apply (optional: tfplan)
- terraform destroy (optional: -auto-approve)
- (Optional for Mac: brew install terragrunt)

### Alternativ deployment with use of Terragrunt
- terragrunt run-all init -upgrade
- terragrunt run-all plan -out tfplan --terragrunt-non-interactive
- terragrunt run-all apply tfplan --terragrunt-non-interactive
- terragrunt run-all destroy --terragrunt-non-interactive

## Requirements
- Azure VNET
- Keyvault
- az CLI installed
- Terraform installed
## Work still in progress
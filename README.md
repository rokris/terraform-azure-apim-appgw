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
- Azure VNET exist in Azure subscription
- Keyvault exist in Azure subscription
- Resourcegroup exist in Azure subscription
- AZ CLI
- Terraform
- Terrgrunt

## APPGW terraform.tfvars
Create a file in the appgw folder named terraform.tfvars
Add variables:
~~~
(terraform.tfvars)

DOMENESHOP_API_TOKEN = "8k3jnk22323k32"
DOMENESHOP_API_SECRET = "xzkj32kjh23kjh23k3ddlk43kya4dVPlHDkFgBFDkUClq4I7ciWiCxsjE"
domain = "example.no"
~~~

## Work still in progress
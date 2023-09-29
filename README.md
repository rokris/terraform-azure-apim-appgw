# terraform-azure-apim-appgw
## Deploy DNS Private zone, Azure API Management, Azure App Gateway

![image](https://github.com/rokris/terraform-azure-apim-appgw/assets/18302354/0f564774-ce3b-4f67-9331-b1a50affba77)

- Edit variables.tf files according to your environment
- Add terraform.tfvars files with correct values
- Login (az login)
- az account set --subscription \<subscription>
- terraform init (optional: -upgrade)
- terraform plan (optional: -out tfplan)
- terraform apply (optional: tfplan)
- terraform destroy (optional: -auto-approve)

The running sequence of terraform deployments
1. terraform_acme_provider
2. private-dns
3. apim
4. appgw

### Alternativ deployment with use of Terragrunt
- terragrunt run-all init -upgrade
- terragrunt run-all plan -out tfplan --terragrunt-non-interactive
- terragrunt run-all apply tfplan --terragrunt-non-interactive
- terragrunt run-all destroy --terragrunt-non-interactive
- (--terragrunt-ignore-dependency-errors)

## Requirements
- Resourcegroup exist in Azure subscription
- Azure Vnet exist in Azure subscription
- Keyvault exist in Azure subscription
- Storage account exist in Azure subscription
- AZ CLI
- Terraform installed
- Terrgrunt installed

## appgw terraform.tfvars
Create a file in the appgw folder named terraform.tfvars
Add variables:
~~~
(terraform.tfvars)

DOMENESHOP_API_TOKEN = "8k3jnk22323k32"
DOMENESHOP_API_SECRET = "xzkj32kjh23kjh23k3ddlk43kya4dVPlHDkFgBFDkUClq4I7ciWiCxsjE"
domain = "example.no"
~~~

## terraform_acme_provider terraform.tfvars
Create a file in the terraform_acme_provider folder named terraform.tfvars
Add variables:
~~~
(terraform.tfvars)

DOMENESHOP_API_TOKEN = "8k3jnk22323k32"
DOMENESHOP_API_SECRET = "xzkj32kjh23kjh23k3ddlk43kya4dVPlHDkFgBFDkUClq4I7ciWiCxsjE"
~~~


## Work still in progress

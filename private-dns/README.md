DNS Private zone and a_records
0. Login (az login)
1. az account set --subscription ng-ti-sandbox
2. terraform -upgrade
3. terraform plan -out tfplan -var-file dev.tfvars
4. terraform apply tfplan
5. terraform destroy -var-file dev.tfvars -auto-approve

Work still in progress
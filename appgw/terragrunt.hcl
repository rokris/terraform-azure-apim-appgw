dependency "terraform_acme_provider" {
  config_path  = "../terraform_acme_provider"
  skip_outputs = true
}

dependency "apim" {
  config_path  = "../apim"
  skip_outputs = true
}

dependency "terraform_acme_provider" {
  config_path  = "../terraform_acme_provider"
  skip_outputs = true
}

dependency "private-dns" {
  config_path  = "../private-dns"
  skip_outputs = true
}
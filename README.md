# terraform-volterra-app-delivery-network

Sample usage

```
variable "api_url" {
  default = "https://acmecorp.console.ves.volterra.io/api"
}

variable "api_p12_file" {
  default = "acmecorp.console.api-creds.p12"
}

variable "api_cert" {
  default = ""
}

variable "api_key" {
  default = ""
}

provider "volterra" {
  api_p12_file = var.api_p12_file
  api_cert     = var.api_p12_file != "" ? "" : var.api_cert
  api_key      = var.api_p12_file != "" ? "" : var.api_key
  api_ca_cert  = var.api_ca_cert
  url          = var.api_url
}

module "wasp" {
  source = "../terraform-volterra-app-delivery-network"
  adn_name = "module-adn-test"
  volterra_namespace = "module-adn-test"
  app_domain = "module-adn-test.adn.helloclouds.app"
}
```
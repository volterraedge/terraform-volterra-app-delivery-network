# terraform-volterra-app-delivery-network

[![Lint Status](https://github.com/volterraedge/terraform-volterra-app-delivery-network/workflows/Lint/badge.svg)](https://github.com/volterraedge/terraform-volterra-app-delivery-network/actions)
[![LICENSE](https://img.shields.io/github/license/volterraedge/terraform-volterra-app-delivery-network)](https://github.com/volterraedge/terraform-volterra-app-delivery-network/blob/main/LICENSE)

This is a terraform module to create Volterra's Application Delivery Network usecase. Read the [Application Delivery Network usecase guide](https://volterra.io/docs/quick-start/app-delivery-network) to learn more.

---

## Overview

![Image of ADN Usecase](https://volterra.io/static/15a56da8dbb948319f81c4d99cc36cea/3353d/top-nea-new.webp)

---

## Prerequisites

### Volterra Account

* Signup For Volterra Account

  If you don't have a Volterra account. Please follow this link to [signup](https://console.ves.volterra.io/signup/)

* Download Volterra API credentials file

  Follow [how to generate API Certificate](https://volterra.io/docs/how-to/user-mgmt/credentials) to create API credentials

* Setup domain delegation

  Follow steps from this [link](https://volterra.io/docs/how-to/app-networking/domain-delegation) to create domain delegation.

### Command Line Tools

* Install terraform

  For homebrew installed on macos, run below command to install terraform. For rest of the os follow the instructions from [this link](https://learn.hashicorp.com/tutorials/terraform/install-cli) to install terraform

  ```bash
  $ brew tap hashicorp/tap
  $ brew install hashicorp/tap/terraform

  # to update
  $ brew upgrade hashicorp/tap/terraform
  ```

* Export the API certificate password as environment variable, this is needed for volterra provider to work
  ```bash
  export VES_P12_PASSWORD=<your credential password>
  ```

---

# Usage Example

```hcl
variable "api_url" {
  #--- UNCOMMENT FOR TEAM OR ORG TENANTS
  # default = "https://<TENANT-NAME>.console.ves.volterra.io/api"
  #--- UNCOMMENT FOR INDIVIDUAL/FREEMIUM
  # default = "https://console.ves.volterra.io/api"
}

# This points the absolute path of the api credentials file you downloaded from Volterra
variable "api_p12_file" {
  default = "path/to/your/api-creds.p12"
}

variable "app_fqdn" {}

variable "namespace" {
  default = ""
}

variable "app_type" {
  default = ""
}

variable "name" {}

locals{
  namespace = var.namespace != "" ? var.namespace : var.name
  app_type  = var.app_type != "" ? var.app_type : var.name
}

terraform {
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = "0.3.0"
    }
  }
}

provider "volterra" {
  api_p12_file = var.api_p12_file
  url          = var.api_url
}

module "app-delivery-network" {
  source             = "volterraedge/app-delivery-network/volterra"
  adn_name           = var.name
  volterra_namespace = local.namespace
  app_domain         = var.app_fqdn
  app_type           = var.app_type
}

output "adn_app_url" {
  value = module.app-delivery-network.app_url
}
```
---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0 |
| <a name="requirement_volterra"></a> [volterra](#requirement\_volterra) | 0.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.0 |
| <a name="provider_volterra"></a> [volterra](#provider\_volterra) | 0.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.hipster_manifest](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.this_kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.apply_manifest](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [volterra_api_credential.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/api_credential) | resource |
| [volterra_app_type.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/app_type) | resource |
| [volterra_http_loadbalancer.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/http_loadbalancer) | resource |
| [volterra_namespace.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/namespace) | resource |
| [volterra_origin_pool.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/origin_pool) | resource |
| [volterra_virtual_k8s.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/virtual_k8s) | resource |
| [volterra_waf.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/waf) | resource |
| [volterra_namespace.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/data-sources/namespace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_adn_name"></a> [adn\_name](#input\_adn\_name) | ADN Name. Also used as a prefix in names of related resources. | `string` | n/a | yes |
| <a name="input_app_domain"></a> [app\_domain](#input\_app\_domain) | FQDN for the app. If you have delegated domain `prod.example.com`, then your app\_domain can be `<app_name>.prod.example.com` | `string` | n/a | yes |
| <a name="input_app_type"></a> [app\_type](#input\_app\_type) | Create a volterra app-type object in shared namespace | `string` | n/a | yes |
| <a name="input_enable_hsts"></a> [enable\_hsts](#input\_enable\_hsts) | Flag to enable hsts for HTTPS loadbalancer | `bool` | `false` | no |
| <a name="input_enable_redirect"></a> [enable\_redirect](#input\_enable\_redirect) | Flag to enable http redirect to HTTPS loadbalancer | `bool` | `true` | no |
| <a name="input_js_cookie_expiry"></a> [js\_cookie\_expiry](#input\_js\_cookie\_expiry) | Javascript cookie expiry time in seconds | `number` | `3600` | no |
| <a name="input_js_script_delay"></a> [js\_script\_delay](#input\_js\_script\_delay) | Javascript challenge delay in miliseconds | `number` | `5000` | no |
| <a name="input_volterra_namespace"></a> [volterra\_namespace](#input\_volterra\_namespace) | Volterra app namespace where the object will be created. This cannot be system or shared ns. | `string` | n/a | yes |
| <a name="input_volterra_namespace_exists"></a> [volterra\_namespace\_exists](#input\_volterra\_namespace\_exists) | Flag to create or use existing volterra namespace | `string` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_url"></a> [app\_url](#output\_app\_url) | Domain VIP to access the application, running on ADN |

# terraform-volterra-app-delivery-network

[![Lint Status](https://github.com/volterraedge/terraform-volterra-app-delivery-network/workflows/Lint/badge.svg)](https://github.com/volterraedge/terraform-volterra-app-delivery-network/actions)
[![LICENSE](https://img.shields.io/github/license/volterraedge/terraform-volterra-app-delivery-network)](https://github.com/volterraedge/terraform-volterra-app-delivery-network/blob/main/LICENSE

This is a terraform module to create Volterra's Application Delivery Network usecase. Read the [Application Delivery Network usecase guide](https://volterra.io/docs/quick-start/app-delivery-network) to learn more.

---

## Assumptions:

* You already have signed up for Volterra account. If not, use this link to [signup](https://console.ves.volterra.io/signup/)

* At the current state, this module requires the user to have team/organization plan of Volterra account

---

## Prerequisites

* Install terraform

  For homebrew installed on macos, run below command to install terraform. For rest of the os follow the instructions from [this link](https://learn.hashicorp.com/tutorials/terraform/install-cli) to install terraform

  ```bash
  $ brew tap hashicorp/tap
  $ brew install hashicorp/tap/terraform

  # to update
  $ brew upgrade hashicorp/tap/terraform
  ```

* Download Volterra API credentials file

  Follow the steps under section `Generate API Certificate` from [how to manage credentials doc](https://volterra.io/docs/how-to/user-mgmt/credentials)


* Export the API certificate password as environment variable

  ```bash
  export VES_P12_PASSWORD=<your credential password>
  ```

* Setup domain delegation

  Follow steps from this [link](https://volterra.io/docs/how-to/app-networking/domain-delegation) to create domain delegation.

---

# Usage Example

```hcl
terraform {
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = "0.0.5"
    }
  }
}

variable "api_url" {
  default = "https://acmecorp.console.ves.volterra.io/api"
}

variable "api_p12_file" {
  default = "acmecorp.console.api-creds.p12"
}

provider "volterra" {
  api_p12_file = var.api_p12_file
  url          = var.api_url
}

module "app-delivery-network" {
  source             = "volterraedge/app-delivery-network/volterra"
  version            = "0.0.1"
  adn_name           = var.name
  volterra_namespace = var.name
  app_domain         = var.domain_name
}

output "adn_app_url" {
  value = module.app-delivery-network.adn_app_url
}
```
---
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.9, != 0.13.0 |
| local | >= 2.0 |
| null | >= 3.0 |
| volterra | 0.0.5 |

## Providers

| Name | Version |
|------|---------|
| local | >= 2.0 |
| null | >= 3.0 |
| volterra | 0.0.5 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| adn\_name | ADN Name. Also used as a prefix in names of related resources. | `string` | n/a | yes |
| app\_domain | FQDN for the app. If you have delegated domain `prod.example.com`, then your app\_domain can be `<app_name>.prod.example.com` | `string` | n/a | yes |
| enable\_hsts | Flag to enable hsts for HTTPS loadbalancer | `bool` | `false` | no |
| enable\_redirect | Flag to enable http redirect to HTTPS loadbalancer | `bool` | `true` | no |
| js\_cookie\_expiry | Javascript cookie expiry time in seconds | `number` | `3600` | no |
| js\_script\_delay | Javascript challenge delay in miliseconds | `number` | `5000` | no |
| volterra\_namespace | Volterra app namespace where the object will be created. This cannot be system or shared ns. | `string` | n/a | yes |
| volterra\_namespace\_exists | Flag to create or use existing volterra namespace | `string` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| adn\_app\_url | Domain VIP to access the application, running on ADN |


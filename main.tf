terraform {
  required_providers {
    mso = {
      source = "CiscoDevNet/mso"
      version = "0.3.2"
    }
  }
}

provider "mso" {
  username = var.adm_username
  password = var.adm_password
  url      = var.adm_url
  domain   = "local"
  insecure = true
  platform = "nd"
}


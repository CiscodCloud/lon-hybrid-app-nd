terraform {
  required_providers {
    mso = {
      source = "CiscoDevNet/mso"
      version = "0.3.2"
    }
  }
}

provider "mso" {
  username = var.ndo_adm_username
  password = var.ndo_adm_password
  url      = var.ndo_adm_url
  domain   = "local"
  insecure = true
  platform = "nd"
}


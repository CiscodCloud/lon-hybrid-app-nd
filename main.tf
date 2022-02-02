terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }

    mso = {
      source = "CiscoDevNet/mso"
      version = "0.4.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }

  }

  #required_version = "~> 1.0.0"
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
}

data "aws_vpc" "oc_vpc" {
  id = var.oc_vpc_id
}

data "aws_subnet" "oc_subnet" {
  id = var.oc_subnet_id
}


# Configure the VMware vSphere Provider
provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}
data "vsphere_datacenter" "dc" {
  name = var.datacenter
# datacenter_id = data.vsphere_datacenter.dc.id

}

data "vsphere_datastore" "datastore" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  # name          = var.network_name
  name   = "${var.tenant_name}|${mso_schema_template_anp.r_anp_new_app.name}|${mso_schema_template_anp_epg.r_epg_new_app_db.name}"
  datacenter_id = data.vsphere_datacenter.dc.id
  depends_on = [mso_schema_template_deploy.r_deploy_tmpl_to_sites, time_sleep.wait_x_seconds, ]
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "time_sleep" "wait_x_seconds" {
   create_duration = "10s" 
   depends_on = [mso_schema_template_deploy.r_deploy_tmpl_to_sites,]
}

resource "random_string" "folder_name_prefix" {
  length    = 10
  min_lower = 10
  special   = false
  lower     = true
}
resource "vsphere_folder" "vm_folder" {
  path          =  "${var.vm_folder}-${random_string.folder_name_prefix.id}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

provider "mso" {
  username = var.ndo_adm_username
  password = var.ndo_adm_password
  url      = var.ndo_adm_url
  domain   = "local"
  insecure = true
  platform = "nd"
}

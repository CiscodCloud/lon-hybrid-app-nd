
#### PROVIDER VARIABLES (LOGIN) #####
variable "ndo_adm_username" {
  type = string
}
variable "ndo_adm_password" {
  type = string
}
variable "ndo_adm_url" {
  type = string
}


#### APP VARIABLES ####

variable "name_new_app" {
  type = string
  default = "eoc"
}

variable "name_new_app_web_server" {
  type = string
  default = "webserver-1"
}


#### INFRA OBJECTS VARIABLES ####

variable "infra_site_id_dcloud_lon" {
  default = "5e15b327120000bd3740f2b2"
}

variable "infra_site_id_dcloud_aws" {
  default = "5f63ac103600007a053683a9"
}

variable "infra_tenant_id_hybrid_tn1" {
  default = "5f63b3063d0000820698459c"
}

variable "infra_bd_name_hybrid_bd" {
  default = "Backend-DB"
}

variable "infra_vrf_name_stretch_vrf" {
  default = "stretch-vrf"
}

variable "infra_schema_id_hybrid_apps" {
  default = "5f63b35d3900009d06e573c8"
}

variable "infra_template_name_shared" {
  default = "shared"
}

variable "infra_template_name_onprem" {
  default = "OnPrem"
}

variable "infra_contract_name_icmp" {
  default = "ccn_icmp"
}

variable "infra_contract_name_onprem_services" {
  default = "ccn_OnPremServices"
}

variable "infra_contract_name_inet_access" {
  default = "ccn_InternetAccess"
}

variable "infra_contract_name_ssh_publish" {
  default = "ccn_SshPublish"
}

variable "infra_contract_name_web_publish" {
  default = "ccn_WebPublish"
}

variable "infra_vmm_domain_name_vm60" {
  default = "vmware60-hybridcloud"
}

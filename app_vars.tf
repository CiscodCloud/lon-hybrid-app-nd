// The vsphere ip address
variable "vsphere_server" {
  type = string
}

// The vsphere user
variable "vsphere_user" {
  type = string
  default = ""
}

// The vsphere password
variable "vsphere_password" {
  type = string
}

// The datacenter the resources will be created in.
variable "datacenter" {
  type = string
}


// The resource pool the virtual machines will be placed in.
variable "resource_pool" {
  type = string
}

// The name of the datastore to use.
variable "datastore_name" {
  type = string
}

// The name of the network to use.
#variable "network_name" {
#  type = string
#}

// The name of the template to use when cloning.
variable "template_name" {
  type = string
}


variable "vm_prefix" {
  type = string
}

variable "vm_folder" {
  type = string
}


variable "web_server_count" {
  default     = 1
  description = "Number of web servers"
}

variable "web_server_prefix" {
  default ="webserver"
}

variable "db_server_prefix" {
  default ="db"
}

// The name prefix of the virtual machines to create.
variable "vm_domain" {
  type = string
}
variable "root_password" {
  type = string
}

variable "db_server_cpu" {
  type = string
}
variable "db_server_memory" {
  type = string
}
variable "web_server_cpu" {
  type = string
}
variable "web_server_memory" {
  type = string
}

#########
variable "web_server_size" {
  default     = "t2.medium"
  description = "Instance type for web server"
}

# variable "vpc_cidr" {
#   default = "10.0.0.0/16"
# }

variable "region" {
  default     = "eu-west-2"
  description = "AWS region"
}

variable "key_name" {
  default ="hybridAppLON"
}
variable "oc_private_key"{
  default = ""
}
variable "ssh_port" {
  default = "22"
}

variable "ssh_user" {
  default = "centos"
}


variable "oc_vpc_id" {
  type = string
}

variable "oc_subnet_id" {
  type = string
}

variable "oc_sg_id" {
  type = string
}

variable "ami_id" {
###  default = "ami-0536d0941c22d3453"
#  default = "ami-0efd4603bb2afccf5"
}

variable "mysql_root_password" {
    type = string
}

variable "mysql_ocuser_password" {
    type = string
}

variable "tenant_name" {
}

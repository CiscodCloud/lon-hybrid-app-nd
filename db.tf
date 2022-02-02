

resource "vsphere_virtual_machine" "dbserver" {
  count            = 1
  name             = "${var.tenant_name}-${var.db_server_prefix}-${random_string.folder_name_prefix.id}-${count.index + 1}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = vsphere_folder.vm_folder.path
  depends_on = [mso_schema_template_deploy.r_deploy_tmpl_to_sites, time_sleep.wait_x_seconds, ]
  
  lifecycle {
    ignore_changes = [disk,]
            }

  num_cpus = var.db_server_cpu
  memory   = var.db_server_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label = "disk0"
    size  = data.vsphere_virtual_machine.template.disks.0.size
    #eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    #thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "${var.db_server_prefix}-${random_string.folder_name_prefix.id}-${count.index + 1}"
        domain    = var.vm_domain
      }
      network_interface {}
    }
  }
}

resource "null_resource" "db_init" {
  count = 1

  provisioner "file" {
    source      = "ansible/"
    destination = "/tmp"
    connection {
      type     = "ssh"
      host     = vsphere_virtual_machine.dbserver[0].default_ip_address
      user     = "root"
      password = var.root_password
      port     = "22"
      agent    = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname --static dbserver-${count.index}",
      "sudo yum install epel-release -y",
      "sudo yum update -y",
      "sudo yum install ansible wget -y",
      "sleep 10s",
      "sudo ansible-playbook -i localhost /tmp/opencart_db.yaml -e \"mysql_root_password=${var.mysql_root_password} mysql_ocuser_password=${var.mysql_ocuser_password}\""
    ]
    connection {
      type     = "ssh"
      host     = vsphere_virtual_machine.dbserver[0].default_ip_address
      user     = "root"
      password = var.root_password
      port     = "22"
      agent    = false
    }
  }
}

resource "random_integer" "priority" {
  min = 0
  max = 1
}

resource "aws_instance" "webserver" {
  depends_on = [aws_security_group.opencart_sg]
  ami                    = var.ami_id
  instance_type          = var.web_server_size
  vpc_security_group_ids = [aws_security_group.opencart_sg.id]
  subnet_id                   = data.aws_subnet.oc_subnet.id
  associate_public_ip_address = true
  key_name = var.key_name
  tags = {
    Name = "${var.web_server_prefix}-1"
  }
}
resource "null_resource" "oc_init" {
  
  depends_on = [aws_instance.webserver, null_resource.db_init]

  provisioner "file" {
    source      = "ansible/"
    destination = "/tmp"
    connection {
      type = "ssh"
      host = aws_instance.webserver.private_ip
      user = var.ssh_user
      port = var.ssh_port
      private_key = var.oc_private_key
    }
  }
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname --static webserver-1",
      "sudo echo 'preserve_hostname: true' >> /etc/cloud/cloud.cfg",
      "sudo yum install epel-release -y",
      "sudo yum update -y",
      "sudo yum install ansible wget -y",
      "sleep 10s",
      
      "sudo ansible-playbook -i localhost /tmp/opencart.yaml",
      "sudo cd /var/www/html/opencart/install; sudo php /var/www/html/opencart/install/cli_install.php install --db_hostname ${vsphere_virtual_machine.dbserver[0].default_ip_address} --db_username ocuser --db_password cisco --db_database opencart --db_driver mysqli --db_port 3306 --username admin --password admin --email youremail@example.com --http_server http://${aws_instance.webserver.public_ip}/opencart/",   
    ]
    connection {
      type = "ssh"
      host = aws_instance.webserver.private_ip
      user = var.ssh_user
      port = var.ssh_port
      private_key = var.oc_private_key
    }

  }
}

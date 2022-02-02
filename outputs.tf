# VPC

#output "webserver_ip" {
#  value = vsphere_virtual_machine.webserver[*].default_ip_address
#}
output "db_ip" {
  value = vsphere_virtual_machine.dbserver[*].default_ip_address
}
output "webserver_public_ip" {
  value = aws_instance.webserver.public_ip
}
output "webserver_pivate_ip" {
  value = aws_instance.webserver.private_ip
}
output "app_url" {
  value = "http://${aws_instance.webserver.public_ip}/opencart"
}


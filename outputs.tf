output "mgmt_url" {
  value = "https://${azurerm_public_ip.sip_public_ip.ip_address}:8443/"
}

output "consul_ui" {
  value = "http://${azurerm_public_ip.consul-pip.ip_address}:8500/"
}

output "app_url" {
  value = "http://${azurerm_public_ip.sip_public_ip.ip_address}:8080/"
}


output "username" {
  value = var.admin_username
}

output "admin_password" {
  value = random_password.bigippassword.result
}
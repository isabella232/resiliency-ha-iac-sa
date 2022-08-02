/**
* Output Variable
* Element : web_instances_ip
* Virtual Server Instance Private IP Addresses for Web
**/
output "web_instances_ip" {
  description = "Private IP addresses for the Web VSI"
  value = local.web_private_ips
}

/**
* Output Variable
* Element : app_instances_ip
* Virtual Server Instance Private IP Addresses for App
**/
output "app_instances_ip" {
  description = "Private IP addresses for the App VSI"
  value = local.app_private_ips
}

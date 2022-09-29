provider "ibm" {
  ibmcloud_api_key = var.api_key
  region           = local.regions[var.zone]
  ibmcloud_timeout = 300
}
# provider "http" {
#   # Configuration options
# }
provider "http-full" {}


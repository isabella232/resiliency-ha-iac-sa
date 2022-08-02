provider "ibm" {
  ibmcloud_api_key = var.api_key
  region           = local.regions[var.zone]
  ibmcloud_timeout = 300
}

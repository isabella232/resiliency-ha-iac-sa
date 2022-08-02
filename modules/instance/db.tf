/**
#################################################################################################################
*                           Virtual Server Instance Section for the DB Instance Module.
*                                 Start Here for the Resources Section 
#################################################################################################################
*/

locals {
  lin_user_data_db = <<-EOUD
  #!/bin/bash
  chmod 0755 /usr/bin/pkexec
  EOUD
}

/**
* Data Volume for DB servers
* Element : volume
* This extra storage volume will be attached to the DB servers as per the user specified size and bandwidth
**/
resource "ibm_is_volume" "data_volume" {
  count          = var.db_vsi_count
  name           = "${var.prefix}volume-${count.index + 1}-${var.zone}"
  resource_group = var.resource_group_name
  profile        = var.tiered_profiles[var.iops_tier]
  zone           = var.zone
  capacity       = var.data_vol_size
}

/**
* Virtual Server Instance for DB
* Element : VSI
* This resource will be used to create a DB VSI as per the user input.
**/
resource "ibm_is_instance" "db" {
  count           = var.db_vsi_count
  name            = "${var.prefix}db-vsi-${count.index + 1}-${var.zone}"
  keys            = var.ssh_key
  image           = var.db_image
  profile         = var.db_profile
  resource_group  = var.resource_group_name
  vpc             = var.vpc_id
  zone            = var.zone
  placement_group = var.db_placement_group_id
  user_data       = local.lin_user_data_db
  depends_on      = [var.db_sg]
  volumes         = [ibm_is_volume.data_volume.*.id[count.index]]

  primary_network_interface {
    subnet          = var.subnet
    security_groups = [var.db_sg]
  }
}

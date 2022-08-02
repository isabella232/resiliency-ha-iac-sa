/**
#################################################################################################################
*                                 Database Instance Output Variable Section
#################################################################################################################
**/


/**
* Output Variable
* Element : DB Target
* Primary IP address for the DB VSI
**/
output "db_target" {
  value       = ibm_is_instance.db.*.primary_network_interface.0.primary_ipv4_address
  description = "Primary IP address for the DB VSI"
  depends_on  = [ibm_is_instance.db]
}

/**
* Output Variable
* Element : Compute instance
* This will return the DB VSI reference
**/
output "db_vsi" {
  value       = ibm_is_instance.db
  description = "Refrence of DB VSI"
  depends_on  = [ibm_is_instance.db]
}

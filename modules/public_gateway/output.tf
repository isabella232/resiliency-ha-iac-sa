/**
#################################################################################################################
*                                 Public Gateway Output Variable Section
#################################################################################################################
**/


/**
* Output Variable 
* Element : pg_id
* This variable will return the ID of the public_gateway created in particular zone
**/

output "pg_id" {
  value = ibm_is_public_gateway.pg.id
  description = "ID's of the public gateways created"
}


/**               
#################################################################################################################
*                                   End of the Output Section 
#################################################################################################################
**/

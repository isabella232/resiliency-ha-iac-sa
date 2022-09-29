/**
#################################################################################################################
*                           Variable Section for the VPC Module.
*                           Start Here of the Variable Section 
#################################################################################################################
*/

/**
* Name: prefix
* Type: String
* Desc: This is the prefix text that will be prepended in every resource name created by this script.
**/
variable "prefix" {
  description = "Prefix for all the resources."
  type        = string
}
/**
* Name: resource_group_name
* Type: String
*/
variable "resource_group_name" {
  description = "Resource Group Name is used to separate the resources in a group."
  type        = string
}

/**               
#################################################################################################################
*                                   End of the Variable Section 
#################################################################################################################
**/
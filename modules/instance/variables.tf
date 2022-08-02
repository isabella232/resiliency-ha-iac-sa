/**
#################################################################################################################
*                           Variable Section for the DB Instance Module.
*                                 Start Here of the Variable Section 
#################################################################################################################
*/

/**
* Name: resource_group_name
* Type: String
* Description: Resource Group Name to be used for resources creation
*/
variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

/**
* Name: prefix
* Type: String
* Description: This is the prefix text that will be prepended in every resource name created by this script.
**/
variable "prefix" {
  description = "Prefix for all the resources."
  type        = string
}

/**
* Name: vpc_id
* Type: String
* Description: This is the vpc ID which will be used for instance module. We are passing this vpc_id from main.tf
**/
variable "vpc_id" {
  description = "Required parameter vpc_id"
  type        = string
}

/**
* Name: subnets
* Type: list
* Description: DB Subnet Ids
**/
variable "subnet" {
  description = "DB subnets Ids. This is required parameter"
  type        = string
}

/**
* Name: db_sg
* Type: string
* Description: Security group ID to be attached with DB server
**/
variable "db_sg" {
  description = "DB Security Group"
  type        = string
}

/**
 * Name: db_vsi_count
 * Type: number
 * Desc: Total Database instances that will be created in the user specified zone.
 **/
variable "db_vsi_count" {
  description = "Total Database instances that will be created in the user specified zone."
  type        = number
}

/**
* Name: ssh_key
* Type: string
* Description: ssh key to be attached with DB servers
**/
variable "ssh_key" {
  description = "ssh keys for the vsi"
  type        = list(any)
}

/**
* Name: db_image
* Desc: This variable will hold the image name for db instance
* Type: String
**/
variable "db_image" {
  description = "Image type you want to use for the DB server. This can be either a custom image or IBM Cloud stock image. Image ID is 41 characters and region-specific.<a href='https://cloud.ibm.com/docs/vpc?topic=vpc-about-images'>Learn more</a>"
  type        = string
}

/**
* Name: db_profile
* Desc: This variable will hold the image profile name for db instance
* Type: String
**/
variable "db_profile" {
  description = "DB Profile"
  type        = string
}


/**
* Name: iops_tier
* Desc: Input/Output per seconds in GB
* Type: number
**/
variable "iops_tier" {
  description = "IOPs (IOPS per GB) tier for db data volume. The possible values are 3, 5 and 10"
  type        = number
  validation {
    condition     = contains(["3", "5", "10", 3, 5, 10], var.iops_tier)
    error_message = "Error: Incorrect value for iops_tier. Allowed values are 3, 5 and 10."
  }
}


/**
* Name: tiered_profiles
* Desc: Tiered profiles for Input/Output per seconds in GBs
* Type: map(any)
**/
variable "tiered_profiles" {
  description = "Tiered profiles for Input/Output per seconds in GBs"
  type        = map(any)
}

/**
* Name: data_vol_size
* Desc: Storage size in GB
* Type: number
**/
variable "data_vol_size" {
  description = "Storage size in GB. The value should be between 10 and 2000"
  type        = number
  validation {
    condition     = var.data_vol_size >= 10 && var.data_vol_size <= 2000
    error_message = "Error: Incorrect value for size. Allowed size should be between 10 and 2000 GB."
  }
}

/**
* Name: zone
* Type: string
* Description: Resources will be created in the user specified zone
**/
variable "zone" {
  description = "Resources will be created in the user specified zone"
  type        = string
}

/**
* Name: db_placement_group_id
* Type: string
* Desc: Placement group ID to be used for Database servers.
**/
variable "db_placement_group_id" {
  description = "Placement group ID to be used for Database servers."
  type        = string
}

/**
#################################################################################################################
*                               End of the Variable Section 
#################################################################################################################
**/

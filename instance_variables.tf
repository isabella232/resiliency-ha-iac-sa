###################################################################################################
###################################################################################################
#####           This Terraform file defines the variables used in Instance Module            ######
#####                                       Instance Module                                  ######
###################################################################################################
###################################################################################################

/**
 * Name: db_vsi_count
 * Type: number
 * Desc: Total Database instances that will be created in the user specified zone.
 *       We have kept the default value to be 2 here. The Database servers count cannot be more than 3.
 **/
variable "db_vsi_count" {
  description = "Total number of db servers to be created in the VPC."
  type        = number
  default     = 2
  validation {
    condition     = var.db_vsi_count <= 3
    error_message = "Database VSI count should be less than or equals to 3."
  }
}

/**
* Name: db_image
* Type: String
* Desc: Custom image ID for the Database VSI. Length of Custom image ID for the Database VSI should be 41 characters.
**/
variable "db_image" {
  description = "Image type you want to use for the db server. This can be either a custom image or IBM Cloud stock image. Image ID is 41 characters and region-specific. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-about-images)"
  type        = string
  validation {
    condition     = length(var.db_image) == 41
    error_message = "Length of Custom image ID for the Database VSI should be 41 characters."
  }
}

/**
* Name: iops_tier
* Desc: Input/Output per seconds in GB. It will be used for the extra storage volume attached with the DB servers.
* Type: number
**/
variable "iops_tier" {
  description = "Enter the IOPs (IOPS per GB) tier for db data volume. Valid values are 3, 5, and 10. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-block-storage-profiles&interface=ui#tiers)"
  type        = number
  default     = 5
  validation {
    condition     = contains(["3", "5", "10", 3, 5, 10], var.iops_tier)
    error_message = "Error: Incorrect value for iops_tier. Allowed values are 3, 5 and 10."
  }
}

/**
* Name: data_vol_size
* Desc: Volume Storage size in GB. It will be used for the extra storage volume attached with the DB servers.
* Type: number
**/
variable "data_vol_size" {
  description = "Data volume storage size for the db server in GB. Value should be in between 10 and 2000."
  type        = number
  default     = 10
  validation {
    condition     = var.data_vol_size >= 10 && var.data_vol_size <= 2000
    error_message = "Error: Incorrect value for size. Allowed size should be between 10 and 2000 GB."
  }
}

/**
* Name: db_profile
* Type: String
* Description: Hardware configuration profile for the Database VSI.
**/
variable "db_profile" {
  description = "VSI profile size which determines size of vCPU, RAM and network bandwidth for the db servers. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles&interface=ui)"
  type        = string
  default     = "cx2-2x4"
}


/**
* Name: tiered_profiles
* Desc: Tiered profiles for Input/Output per seconds in GBs
* Type: map(any)
**/
locals {
  tiered_profiles = {
    "3"  = "general-purpose"
    "5"  = "5iops-tier"
    "10" = "10iops-tier"
  }
}


/**
#################################################################################################################
*                               End of the Variable Section 
#################################################################################################################
**/


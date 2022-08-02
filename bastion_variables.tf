###################################################################################################
###################################################################################################
#####           This Terraform file defines the variables used in Bastion Modules            ######
#####                                 Bastion Modules                                        ######
###################################################################################################
###################################################################################################

/**
* Name: enable_floating_ip
* Description: Determines whether to enable floating IP for Bastion server or not. Give true or false.
**/
locals  {
  enable_floating_ip  = true
}

/**
* Name: bastion_image
* Type: String
* Description: This is the image ID used for Bastion VSI.
**/
variable "bastion_image" {
  description = "Image type you want to use for the bastion server. This can be either a custom image or IBM Cloud stock image. Image ID is 41 characters and region-specific. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-about-images)"
  type        = string
  validation {
    condition     = length(var.bastion_image) == 41
    error_message = "Length of Custom image ID for the Bastion VSI should be 41 characters."
  }
}

/**
* Name: public_ip_address_list
* Type: list
* Description: This is the list of User's Public IP address which will be used to login to Bastion VSI in the format X.X.X.X
*              Please update your public IP address every time before executing terraform apply. As your Public IP address could be dynamically changing each day.
*              To get your Public IP you can use command <dig +short myip.opendns.com @resolver1.opendns.com> or visit "https://www.whatismyip.com"
**/
variable "public_ip_addresses" {
  description = "Comma-separated allowed list of host IP addresses to access the bastion server."
  type        = string
  validation {
    condition     = can([for y in formatlist("%s/32", [for x in split(",", var.public_ip_addresses) : trimspace(x)]) : regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(/((?:[1-9])|(?:[1-2][0-9])|(?:3[0-2])))$", y)])
    error_message = "Error: Format of the provided IP addresses in the list is not valid."
  }
  validation {
    condition     = alltrue([for x in formatlist("%s/32", [for x in split(",", var.public_ip_addresses) : trimspace(x)]) : !can(regex("(^0\\.)|(^10\\.)|(^100\\.6[4-9]\\.)|(^100\\.[7-9][0-9]\\.)|(^100\\.1[0-1][0-9]\\.)|(^100\\.12[0-7]\\.)|(^127\\.)|(^169\\.254\\.)|(^172\\.1[6-9]\\.)|(^172\\.2[0-9]\\.)|(^172\\.3[0-1]\\.)|(^192\\.0\\.0\\.)|(^192\\.0\\.2\\.)|(^192\\.88\\.99\\.)|(^192\\.168\\.)|(^198\\.1[8-9]\\.)|(^198\\.51\\.100\\.)|(^203\\.0\\.113\\.)|(^22[4-9]\\.)|(^23[0-9]\\.)|(^24[0-9]\\.)|(^25[0-5]\\.)", x))])
    error_message = "Error: Provided IP address in the list is not a public IP address."
  }
}
locals {
  public_ip_address_list = formatlist("%s/32", [for x in split(",", var.public_ip_addresses) : trimspace(x)])
}

/**
  * IP Count for the Bastion subnet
  * Value of bastion_ip_count will be from following 
  * 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192 and 16384
  * Please enter the IP count depending on the total_instance configuration
  */
variable "bastion_ip_count" {
  description = "Total host IPs for the bastion subnet. Valid values 8, 16, 32, 64."
  type        = number
  default     = 8
  validation {
    condition     = contains([8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384], var.bastion_ip_count)
    error_message = "Error: Incorrect value for bastion_ip_count. Allowed values are 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384."
  }
}


/**
* Name: bastion_ssh_key_var_name
* Type: String
* Description: This is the name of the ssh key which will be created dynamically on the bastion VSI. So that, users can login to Web/App/DB servers via Bastion server only.
*              If you are passing "bastion-ssh-key" name here, then the ssh key will create on IBM cloud dynamically with name "{var.prefix}-bastion-ssh-key".
*              As seen, this ssh key name will contain the prefix name as well.
**/
variable "bastion_ssh_key_var_name" {
  description = "IBM Cloud object name for bastion server SSH key."
  type        = string
  default     = "bastion-ssh-key"
}

/**
* Name: bastion_profile
* Type: String
* Description: Specify the profile needed for Bastion VSI.
**/
variable "bastion_profile" {
  description = "VSI profile size which determines size of vCPU, RAM and network bandwidth for the bastion server. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles&interface=ui)"
  type        = string
  default     = "cx2-2x4"
}



/**               
#################################################################################################################
*                                   End of the Variable Section 
#################################################################################################################
**/



################################################################################################
################################################################################################
####                This Terraform file defines the variables used in All Modules          #####
####                                     All Modules                                       #####
################################################################################################
################################################################################################


/**
* Name: regions
* Type: map(any)
* Desc: Region and zones mapping
**/
locals {

  alb_port = 80 # App load balancer listener port

  wlb_port = 80 # Web load balancer listener port

  regions = {
    "us-south-1" = "us-south" #Dallas
    "us-south-2" = "us-south"
    "us-south-3" = "us-south"
    "us-east-1"  = "us-east" #Washington DC
    "us-east-2"  = "us-east"
    "us-east-3"  = "us-east"
    "eu-gb-1"    = "eu-gb" #London
    "eu-gb-2"    = "eu-gb"
    "eu-gb-3"    = "eu-gb"
    "eu-de-1"    = "eu-de" #Frankfurt
    "eu-de-2"    = "eu-de"
    "eu-de-3"    = "eu-de"
    "jp-tok-1"   = "jp-tok" #Tokyo
    "jp-tok-2"   = "jp-tok"
    "jp-tok-3"   = "jp-tok"
    "au-syd-1"   = "au-syd" #Sydney
    "au-syd-2"   = "au-syd"
    "au-syd-3"   = "au-syd"
    "jp-osa-1"   = "jp-osa" #Osaka
    "jp-osa-2"   = "jp-osa"
    "jp-osa-3"   = "jp-osa"
    "br-sao-1"   = "br-sao" #Sao Paulo
    "br-sao-2"   = "br-sao"
    "br-sao-3"   = "br-sao"
    "ca-tor-1"   = "ca-tor" #Toronto
    "ca-tor-2"   = "ca-tor"
    "ca-tor-3"   = "ca-tor"
  }
}

/**
* Name: zone
* Type: String
* Desc: Zone to be used for resources creation
*/
variable "zone" {
  description = "Enter the zone where the VPC resources will be deployed. [Learn more](https://cloud.ibm.com/docs/overview?topic=overview-locations#table-mzr)"
  type        = string
}

/**
* Name: api_key
* Type: String
* Desc: Please enter the IBM Cloud API key
*/
variable "api_key" {
  description = "This is the API key for the IBM Cloud account used to create the resources. [Learn more](https://cloud.ibm.com/docs/account?topic=account-userapikey&interface=ui)"
  type        = string
  sensitive   = true
}

/**
* Name: user_ssh_key
* Type: list
* Desc: This is the list of the existing ssh key/keys of user which will be used to login to the Bastion server. For example "first-ssh-key,second-ssh-key". You can check your key name in IBM cloud.
*              If you don't have an existing key, then create one using <ssh-keygen -t rsa -b 4096 -C "user_ID"> command. And create a ssh key in IBM cloud with the public contents of file ~/.ssh/id_rsa.pub.
**/
variable "user_ssh_keys" {
  description = "Comma-separated list of names of SSH key configured in your IBM Cloud account that is used to establish a connection to the bastion server. Ensure the SSH key is present in the same region where the 3-tier app is being deployed.[Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys)"
  type        = string
}

locals {
  user_ssh_key_list = [for x in split(",", var.user_ssh_keys) : trimspace(x)]
}


/**
* Name: resource_group_name
* Type: String
* Desc: Resource Group Name to be used for resources creation
*/
variable "resource_group_name" {
  description = "Resource group name from your IBM Cloud account where the VPC resources will be deployed."
  type        = string
  validation {
    condition     = length(var.resource_group_name) == 32
    error_message = "Length of Resource Group Name should be 32 characters."
  }
}

/**
* Name: prefix
* Type: String
* Desc: Please enter the prefix, which will be added in the resource's name. \nLength of prefix should be less than 11 characters. \nFor the prefix value only a-z, A-Z and 0-9 are allowed, the prefix should start with a character, and the prefix should end a with hyphen(-).
**/
variable "prefix" {
  description = "An alphanumeric prefix identifier that will be added to the beginning of all of the VPC resources. It should end with a hyphen (-) and does not exceed 11 characters."
  type        = string
  validation {
    condition     = length(var.prefix) <= 11
    error_message = "Length of prefix should be less than 11 characters."
  }
  validation {
    condition     = can(regex("^[A-Za-z][-0-9A-Za-z]*-$", var.prefix))
    error_message = "For the prefix value only a-z, A-Z and 0-9 are allowed, the prefix should start with a character, and the prefix should end a with hyphen(-)."
  }
}
  
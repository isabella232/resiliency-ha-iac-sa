###################################################################################################
###################################################################################################
#####        This Terraform file defines the variables used in Instance Group Module         ######
#####                                    Instance Group Module                               ######
###################################################################################################
###################################################################################################


/**
* Name: web_config
* Desc: This web_config map will be passed to the Instance Group Module
*       application_port  : This is the Application port for Web Servers. It could be same as the application load balancer listener port.         
*       memory_percent    : Average target Memory Percent for Memory policy of Web Instance Group
*       network_in        : Average target Network in (Mbps) for Network in policy of Web Instance Group
*       network_out       : Average target Network out (Mbps) for Network out policy of Web Instance Group"
**/
locals {
  web_config = {
    application_port = local.wlb_port
    memory_percent   = "70"   # Range 10% - 90%
    network_in       = "4000" # Range 1 - 100000
    network_out      = "4000" # Range 1 - 100000
  }
}

/**
* Name: web_instance_profile
* Type: String
* Desc: Hardware configuration profile for the Web VSI.
**/
variable "web_instance_profile" {
  description = "VSI profile size which determines size of vCPU, RAM and network bandwidth for the web servers. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles&interface=ui)"
  type        = string
  default     = "cx2-2x4"
}

/**
* Name: web_image
* Type: String
* Description: This is the image ID used for web VSI.
**/
variable "web_image" {
  description = "Image type you want to use for the web server. This can be either a custom image or IBM Cloud stock image. Image ID is 41 characters and region-specific. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-about-images)"
  type        = string
  validation {
    condition     = length(var.web_image) == 41
    error_message = "Length of Custom image ID for the Web VSI should be 41 characters."
  }
}

/**
* Name: web_max_servers_count
* Type: number
* Desc: Maximum Web servers count for the Web Instance group
**/
variable "web_max_servers_count" {
  description = "Maximum web server count that the instance group can scale up to. Allowed value is between 1 and 1000. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles&interface=ui)"
  type        = number
  default     = 6
  validation {
    condition     = var.web_max_servers_count >= 1 && var.web_max_servers_count <= 1000
    error_message = "Error: Incorrect value for web_max_servers_count. Allowed value should be between 1 and 1000."
  }
}


/**
* Name: web_min_servers_count
* Type: number
* Desc: Minimum Web servers count for the Web Instance group
**/
variable "web_min_servers_count" {
  description = "Minimum web server count that the instance group cannot go below. Allowed value is between 1 and 1000. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles&interface=ui)"
  type        = number
  default     = 3
  validation {
    condition     = var.web_min_servers_count >= 1 && var.web_min_servers_count <= 1000
    error_message = "Error: Incorrect value for web_min_servers_count. Allowed value should be between 1 and 1000."
  }
}

/**
* Name: web_cpu_threshold
* Type: number
* Desc: Average target CPU Percent for CPU policy of Web Instance Group.
**/
variable "web_cpu_threshold" {
  description = "The average utilization the web server instance group should achieve. This value defines when to add or remove web server instances to the group. Value should be between 10 and 90. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-auto-scale-instance-group&interface=ui)"
  type        = number
  default     = 70
  validation {
    condition     = var.web_cpu_threshold >= 10 && var.web_cpu_threshold <= 90
    error_message = "Error: Incorrect value for web_cpu_threshold. Allowed value should be between 10 and 90."
  }
}

/**
* Name: web_aggregation_window
* Type: number
* Desc: Specify the aggregation window. 
*       The aggregation window is the time period in seconds 
*       that the instance group manager monitors each instance and determines the average utilization.
**/
variable "web_aggregation_window" {
  description = "The aggregation window is the time period in seconds that the instance group manager monitors each instance and determines the average utilization for the web servers group. Value should be between 90 to 600. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-auto-scale-instance-group&interface=ui)"
  type        = number
  default     = 90
  validation {
    condition     = var.web_aggregation_window >= 90 && var.web_aggregation_window <= 600
    error_message = "Error: Incorrect value for web_aggregation_window. Allowed value should be between 90 and 600."
  }
}


/**
* Name: web_cooldown_time
* Type: number
* Desc: Specify the cool down period, 
*              the number of seconds to pause further scaling actions after scaling has taken place.
**/
variable "web_cooldown_time" {
  description = "The cooldown period is the time in seconds to pause further scaling actions after scaling takes place for the web servers. Value should be between 120 and 3600. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-auto-scale-instance-group&interface=ui)"
  type        = number
  default     = 120
  validation {
    condition     = var.web_cooldown_time >= 120 && var.web_cooldown_time <= 3600
    error_message = "Error: Incorrect value for web_cooldown_time. Allowed value should be between 120 and 3600."
  }
}

##############################################################################################################
##############################################################################################################
################                         APP Instance Group Variables                        #################
##############################################################################################################
##############################################################################################################

/**
* Name: app_config
* Desc: This app_config map will be passed to the Instance Group Module
*       application_port  : This is the Application port for App Servers. It could be same as the application load balancer listener port.
*       memory_percent    : Average target Memory Percent for Memory policy of App Instance Group
*       network_in        : Average target Network in (Mbps) for Network in policy of App Instance Group
*       network_out       : Average target Network out (Mbps) for Network out policy of App Instance Group"
*       instance_profile  : Hardware configuration profile for the App VSI.
**/
locals {
  app_config = {
    application_port = local.alb_port
    memory_percent   = "70"   # Range 10% - 90%
    network_in       = "4000" # Range 1 - 100000
    network_out      = "4000" # Range 1 - 100000
  }
}

/**
* Name: app_instance_profile
* Type: String
* Desc: Hardware configuration profile for the App VSI.
**/
variable "app_instance_profile" {
  description = "VSI profile size which determines size of vCPU, RAM and network bandwidth for the app servers. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles&interface=ui)"
  type        = string
  default     = "cx2-2x4"
}

/**
* Name: app_image
* Type: String
* Desc: This is the image ID used for app VSI.
**/
variable "app_image" {
  description = "Image type you want to use for the app server. This can be either a custom image or IBM Cloud stock image. Image ID is 41 characters and region-specific. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-about-images)"
  type        = string
  validation {
    condition     = length(var.app_image) == 41
    error_message = "Length of Custom image ID for the App VSI should be 41 characters."
  }
}

/**
* Name: app_max_servers_count
* Type: number
* Desc: Maximum App servers count for the App Instance group
**/
variable "app_max_servers_count" {
  description = "Maximum app server count that the instance group can scale up to. Allowed value is between 1 and 1000. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles&interface=ui)"
  type        = number
  default     = 6
  validation {
    condition     = var.app_max_servers_count >= 1 && var.app_max_servers_count <= 1000
    error_message = "Error: Incorrect value for app_max_servers_count. Allowed value should be between 1 and 1000."
  }
}


/**
* Name: app_min_servers_count
* Type: number
* Desc: Minimum App servers count for the App Instance group
**/
variable "app_min_servers_count" {
  description = "Minimum app server count that the instance group cannot go below. Allowed value is between 1 and 1000. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles&interface=ui)"
  type        = number
  default     = 3
  validation {
    condition     = var.app_min_servers_count >= 1 && var.app_min_servers_count <= 1000
    error_message = "Error: Incorrect value for app_min_servers_count. Allowed value should be between 1 and 1000."
  }
}

/**
* Name: app_cpu_threshold
* Type: number
* Desc: Average target CPU Percent for CPU policy of App Instance Group.
**/
variable "app_cpu_threshold" {
  description = "The average utilization the app server instance group should achieve. This value defines when to add or remove app server instances to the group. Value should be between 10 and 90. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-auto-scale-instance-group&interface=ui)"
  type        = number
  default     = 70
  validation {
    condition     = var.app_cpu_threshold >= 10 && var.app_cpu_threshold <= 90
    error_message = "Error: Incorrect value for app_cpu_threshold. Allowed value should be between 10 and 90."
  }
}

/**
* Name: app_aggregation_window
* Type: number
* Desc: Specify the aggregation window. 
*       The aggregation window is the time period in seconds 
*       that the instance group manager monitors each instance and determines the average utilization.
**/
variable "app_aggregation_window" {
  description = "The aggregation window is the time period in seconds that the instance group manager monitors each instance and determines the average utilization for the app servers group. Value should be between 90 to 600. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-auto-scale-instance-group&interface=ui)"
  type        = number
  default     = 90
  validation {
    condition     = var.app_aggregation_window >= 90 && var.app_aggregation_window <= 600
    error_message = "Error: Incorrect value for app_aggregation_window. Allowed value should be between 90 and 600."
  }
}


/**
* Name: app_cooldown_time
* Type: number
* Desc: Specify the cool down period, 
*              the number of seconds to pause further scaling actions after scaling has taken place.
**/
variable "app_cooldown_time" {
  description = "The cooldown period is the time in seconds to pause further scaling actions after scaling takes place for the app servers. Value should be between 120 and 3600. [Learn more](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-auto-scale-instance-group&interface=ui)"
  type        = number
  default     = 120
  validation {
    condition     = var.app_cooldown_time >= 120 && var.app_cooldown_time <= 3600
    error_message = "Error: Incorrect value for app_cooldown_time. Allowed value should be between 120 and 3600."
  }
}

/**
#################################################################################################################
*                               End of the Variable Section 
#################################################################################################################
**/

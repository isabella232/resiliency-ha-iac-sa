###################################################################################################
###################################################################################################
#####           This Terraform file defines the variables used in File_Share Modules            ######
#####                                 File_Share Modules                                        ######
###################################################################################################
###################################################################################################

/**
* Name: enable_file_share
* Type: Boolean
* Desc: This creates File Share storage for the App Tier to support stateful use case. Select true or false.
**/
variable "enable_file_share" {
  description = "This creates File Share storage for the App Tier to support stateful use case. Select true or false."
  type        = bool
  default     = false
}

/**
* Name: share_size
* Type: String
* Desc: File Share storage size in GB. Value should be in between 10 and 32000.
*   Min Value: 10 GB
*   Max Value: 32000 GB
**/
variable "share_size" {
  description = "File Share storage size in GB. Value should be in between 10 and 32000."
  type        = number
  default     = 500
}

/**
* Name: share_profile
* Type: String
* Desc: Enter the IOPs (IOPS per GB) tier for File Share storage. Valid values are 3, 5, and 10.
* Possible Values are tier-3iops, tier-5iops and tier-10iops
**/
variable "share_profile" {
  description = "Enter the IOPs (IOPS per GB) tier for File Share storage. Valid values are 3, 5, and 10."
  type        = string
  default     = "tier-3iops"
}

/**
* The below local sections are used for the checking the replica zone value when file share is enabled. 
**/
locals {
  replica_zone_empty_check            = var.enable_file_share == true ? (var.replica_zone == "" ? false : true) : true
  replica_zone_empty_check_intimation = "replica zone can not be empty when enable_file_share is false"
  replica_zone_empty                  = regex("^${local.replica_zone_empty_check_intimation}$", (local.replica_zone_empty_check ? local.replica_zone_empty_check_intimation : ""))
}

/**
* The below local sections are used for the processing the replica zone value when file share is disabled.
**/
locals {
  process_replica_zone = var.replica_zone == "" ? var.zone : var.replica_zone
}

/**
* The below local sections are used for the checking the replica zone value provided by user that it's in the same region as zone value. 
**/
locals {
  replica_region_check = var.replica_zone == "" ? true : (split("-", local.process_replica_zone)[0] == split("-", var.zone)[0] ? ((split("-", local.process_replica_zone)[1] == split("-", var.zone)[1]) ? true : false) : false)
  region_intimation    = "replica zone is not in the same region"
  region_check         = regex("^${local.region_intimation}$", (local.replica_region_check ? local.region_intimation : ""))
}

/**
* The below local sections are used for the checking the replica zone value is not same as the zone value. 
**/
locals {
  replica_zone_check = var.replica_zone == "" || (local.replica_region_check == false) ? true : (split("-", local.process_replica_zone)[2] == split("-", var.zone)[2] ? false : true)
  zone_intimation    = "replica zone is in the same zone"
  zone_check         = regex("^${local.zone_intimation}$", (local.replica_zone_check ? local.zone_intimation : (local.replica_zone_check ? local.zone_intimation : "")))
}

/**
* Name: replica_zone
* Desc: Enter the zone the replica for the File Share storage will be created e.g. us-south-1, us-east-1, etc.
* Type: String
**/
variable "replica_zone" {
  description = "Enter the zone the replica for the File Share storage will be created e.g. us-south-1, us-east-1, etc."
  type        = string
  default     = ""
  validation {
    condition     = var.replica_zone == "" ? true : contains(["1", "2", "3"], split("-", var.replica_zone)[2])
    error_message = "The specified replica_zone is out of applicable zones for this region."
  }
}

/**
* Name: replication_cron_spec
* Type: String
* Desc: Enter the file share replication schedule in Linux crontab format.
* You can choose how often you want to sync changes from the source share to the replica. 
* You can specify replication using a cron-spec (https://en.wikipedia.org/wiki/Cron)
* Replications must be scheduled at least one hour apart. 
* If both "day of month" (field 3) and "day of week" (field 5) are restricted (not contain "*"),then one or both must match the current day.
#
# ┌─────minute (0 - 59)
# │ ┌─────hour (0 - 23)
# │ │ ┌───── day of the month (1 - 31)
# │ │ │ ┌───── month (1 - 12)
# │ │ │ │ ┌───── day of the week (0 - 6) (Sunday to Saturday;7 is also Sunday on some systems)
# │ │ │ │ │        
# │ │ │ │ │
# * * * * * 
#
* Example: "45 23 * * 6", this will replicate data at 23:45 (11:45 PM) every Saturday.
* Default value is “00 08 * * *”, this will replicate data at  08:00AM daily.
**/
variable "replication_cron_spec" {
  description = "Enter the file share replication schedule in Linux crontab format."
  type        = string
  default     = "00 08 * * *"
}

locals {
  date         = formatdate("YYYY-MM-DD", timestamp())
  host         = "https://${var.region}.iaas.cloud.ibm.com/v1/shares"
  query_string = "?generation=2&version=${local.date}"
  shareUrl     = "${local.host}${local.query_string}"

  ### File Share related Variables
  share_size    = var.share_size
  share_name    = "${var.prefix}file-share"
  share_profile = var.share_profile
  target_name   = "${local.share_name}-target"

  ### Replica File Share related Variables
  replica_name        = "${local.share_name}-replica"
  replica_zone        = var.replica_zone
  replica_target_name = "${local.replica_name}-target"


  ### FileShare Data
  fileShareData = jsonencode(
    {
      "size" : "${local.share_size}",
      "targets" : [{ "name" : "${local.target_name}", "vpc" : { "id" : "${var.vpc_id}" } }],
      "name" : "${local.share_name}",
      "profile" : { "name" : "${local.share_profile}" },
      "zone" : { "name" : "${var.zone}" },
      "resource_group" : { "id" : "${var.resource_group_name}" },
  })
}

/**
* Data Resource
* Element : Auth token 
* Retrieve information about your IAM access token. 
* You can use this token to authenticate with the IBM Cloud platform.
**/
data "ibm_iam_auth_token" "auth_token" {}

/**
Data Resource
Element : File share.
This is to create the File Share during terraform apply.
**/
data "http" "create_file_share" {
  count    = var.enable_file_share == true ? 1 : 0
  provider = http-full
  url      = local.shareUrl
  method   = "POST"
  request_headers = {
    Accept        = "application/json"
    Authorization = data.ibm_iam_auth_token.auth_token.iam_access_token
  }
  request_body = local.fileShareData
}

/**
* This block is for time sleep for File share. 
* Element : Wait for 90seconds.
**/
resource "time_sleep" "wait_90_seconds" {
  count           = var.enable_file_share == true ? 1 : 0
  depends_on      = [data.http.create_file_share]
  create_duration = "90s"
}

/**
Locals
This extracts the File share ID and File share Target ID from the json encoded http data source attribute.
**/
locals {
  response_fs = var.enable_file_share == true ? jsondecode(data.http.create_file_share[0].response_body) : null
  fsID        = local.response_fs != null ? local.response_fs.id : 0
  fsTargetID  = local.response_fs != null ? local.response_fs.targets[0].id : 0

  ## Replica File Share
  replicaShareData = jsonencode(
    {
      "source_share" : { "id" : "${local.fsID}" },
      "name" : "${local.replica_name}",
      "profile" : { "name" : "${local.share_profile}" },
      "replication_cron_spec" : "${var.replication_cron_spec}",
      "targets" : [{ "name" : "${local.replica_target_name}", "vpc" : { "id" : "${var.vpc_id}" } }],
      "zone" : { "name" : "${local.replica_zone}" },
  })
}

/**
Data Resource
Element : File share Replica.
This is to create the File Share Replica during terraform apply.
**/
data "http" "create_replica_file_share" {
  count    = var.enable_file_share == true ? 1 : 0
  provider = http-full
  url      = local.shareUrl
  method   = "POST"
  request_headers = {
    Accept        = "application/json"
    Authorization = data.ibm_iam_auth_token.auth_token.iam_access_token
  }
  request_body = local.replicaShareData
  depends_on   = [time_sleep.wait_90_seconds, data.http.create_file_share]
}

/**
Locals
This extracts the Replica File share ID and Replica File share Target ID from the json encoded http data source attribute.
**/
locals {
  share_id            = local.fsID
  share_target_id     = local.fsTargetID
  share_target_url    = var.enable_file_share == true ? "${local.host}/${local.fsID}/targets/${local.fsTargetID}${local.query_string}" : ""
  response_replica_fs = var.enable_file_share == true ? jsondecode(data.http.create_replica_file_share[0].response_body) : null
  rs_id               = local.response_replica_fs != null ? local.response_replica_fs.id : 0
  rs_target_id        = local.response_replica_fs != null ? local.response_replica_fs.targets[0].id : 0
}

/**
Data Resource
Element : File share mount target.
This is to create the mount target during terraform apply.
**/
data "http" "mount_target" {
  count = var.enable_file_share == true ? 1 : 0
  url   = local.share_target_url
  request_headers = {
    Accept        = "application/json"
    Authorization = "${data.ibm_iam_auth_token.auth_token.iam_access_token}"
  }
  depends_on = [data.http.create_replica_file_share, ]
}

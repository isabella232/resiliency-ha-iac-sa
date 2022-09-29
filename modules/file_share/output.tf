/**
#################################################################################################################
*                                 File Share Module Output Variable Section
#################################################################################################################
**/

/* Output Variable for File Share
* This variable will return File share name.
**/
output "share_name" {
  value = local.share_name
}

/* Output Variable for File Share.
* This variable will return File share ID and File share replica ID.
**/
output "FILE_SHARE" {
  value = merge(
    { "SHARE" = merge(
      { "ID" = local.fsID },
      { "TARGET_ID" = local.fsTargetID }
    ) },
    { "REPLICA" = merge(
      { "ID" = local.rs_id },
      { "TARGET_ID" = local.rs_target_id }
    ) }
  )
}

/** Output variable For Mount Path.
* This variable will return the File share target mount path used for mounting nfs in app servers.
**/
output "mountPath" {
  value = local.targetData != null ? local.targetData.mount_path : ""
}



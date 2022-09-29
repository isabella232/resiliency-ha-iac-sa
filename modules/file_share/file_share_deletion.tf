/** 
Locals
This local variable constructs the url for fetching the Replica file share metadata using the "http" data source.
The values retrieved will be Replica share ID, Replica share target ID, Replica share target url and File share url.
**/
locals {
  replica_share_id         = local.rs_id
  replica_share_target_id  = local.rs_target_id
  replica_share_target_url = var.enable_file_share == true ? "${local.host}/${local.replica_share_id}/targets/${local.replica_share_target_id}?generation=2&version=${local.date}" : ""
  getFileShareUrl          = "${local.host}${local.query_string}&replication_role=source&name=${local.share_name}"
}

locals {
  targetData = var.enable_file_share == true ? jsondecode(data.http.mount_target[0].response_body) : null
}

/** 
Element : null resource.
This is used to delete the File Share during terraform destroy.
**/
resource "null_resource" "delete_file_share" {
  triggers = {
    host                    = local.host
    replica_share_target_id = local.replica_share_target_id
    replica_share_id        = local.replica_share_id
    share_target_id         = local.share_target_id
    share_id                = local.share_id
    api_key                 = var.api_key
    region                  = var.region
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
     echo 'Login to ibmcloud'
     ibmcloud config --check-version=false
     ibmcloud login -r ${self.triggers.region} --apikey ${self.triggers.api_key}  
     export oauth_token=` ibmcloud iam oauth-tokens |awk '{print $4}'` 
     curl -X DELETE "${self.triggers.host}/${self.triggers.share_id}?version=2022-05-03&generation=2" -H "Authorization: $oauth_token"
     sleep 5
     export oauth_token=` ibmcloud iam oauth-tokens |awk '{print $4}'` 
     curl -X DELETE "${self.triggers.host}/${self.triggers.replica_share_id}?version=2022-05-03&generation=2" -H "Authorization: $oauth_token" 
    EOT
  }
  depends_on = [time_sleep.wait_90_seconds, data.http.create_file_share, ]
}

/** 
Element : null resource.
This is used to delete the File Share replica relation during terraform destroy.
**/
resource "null_resource" "delete_file_share_replica_relation" {
  triggers = {
    host                    = local.host
    replica_share_target_id = local.replica_share_target_id
    replica_share_id        = local.replica_share_id
    share_target_id         = local.share_target_id
    share_id                = local.share_id
    api_key                 = var.api_key
    region                  = var.region
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
     echo 'Login to ibmcloud'
     ibmcloud config --check-version=false
     ibmcloud login -r ${self.triggers.region} --apikey ${self.triggers.api_key}  
     export oauth_token=` ibmcloud iam oauth-tokens |awk '{print $4}'`     
     curl -X DELETE "${self.triggers.host}/${self.triggers.replica_share_id}/source?version=2022-05-03&generation=2" -H "Authorization: $oauth_token"
     sleep 20
    EOT
  }
  depends_on = [
    null_resource.delete_file_share,
  ]
}

/** 
Element : null resource.
This is used to delete the File Share mounts during terraform destroy.
**/
resource "null_resource" "delete_file_shares_mounts" {
  triggers = {
    host                    = local.host
    replica_share_target_id = local.replica_share_target_id
    replica_share_id        = local.replica_share_id
    share_target_id         = local.share_target_id
    share_id                = local.share_id
    api_key                 = var.api_key
    region                  = var.region
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
     echo 'Login to ibmcloud'
     ibmcloud config --check-version=false
     ibmcloud login -r ${self.triggers.region} --apikey ${self.triggers.api_key}  
     export oauth_token=` ibmcloud iam oauth-tokens |awk '{print $4}'`     
     curl -X DELETE "${self.triggers.host}/${self.triggers.replica_share_id}/targets/${self.triggers.replica_share_target_id}?version=2022-05-03&generation=2" -H "Authorization: $oauth_token"
     curl -X DELETE "${self.triggers.host}/${self.triggers.share_id}/targets/${self.triggers.share_target_id}?version=2022-05-03&generation=2" -H "Authorization: $oauth_token"
     sleep 20
    EOT
  }
  depends_on = [
    null_resource.delete_file_share, null_resource.delete_file_share_replica_relation,
  ]
}

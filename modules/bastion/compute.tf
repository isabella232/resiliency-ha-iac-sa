/**
#################################################################################################################
*                           Resources Section for the Bastion Module.
#################################################################################################################
*/

# Using the data source to get the tokens object 
data "ibm_iam_auth_token" "auth_token" {}

data "ibm_is_image" "bastion_os" {
  identifier = var.bastion_image
}

/**
* This local block is used to declare the local variables for linux and windows Bastion server user-data.
* In these Bastion server user-data, we are creating the bastion ssh keys on IBM cloud. This ssh key will then be attached 
* to the app/web/db servers. Thus only bastion server will have access to these servers.
**/

locals {

  lin_user_data = <<-EOUD
        #!/bin/bash
        if echo "${data.ibm_is_image.bastion_os.os}" | grep -i "ubuntu"
        then
        sudo apt update -y
        else
        sudo yum update -y
        fi
        ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa  2>&1 >/dev/null
        cur_date=$(date "+%Y-%m-%d")
        pub_key=`cat ~/.ssh/id_rsa.pub`
        export oauth_token="${data.ibm_iam_auth_token.auth_token.iam_access_token}"
        vpc_api_endpoint="https://${var.region}.iaas.cloud.ibm.com"
        curl -X POST "$vpc_api_endpoint/v1/keys?version=$cur_date&generation=2" -H "Authorization: $oauth_token" -d '{
            "name":"${var.prefix}${var.bastion_ssh_key}",
            "resource_group":{"id":"${var.resource_group_name}"},
            "public_key":"'"$pub_key"'",
            "type":"rsa"
        }'
        curl -sL https://raw.githubusercontent.com/IBM-Cloud/ibm-cloud-developer-tools/master/linux-installer/idt-installer | bash
        ibmcloud plugin install vpc-infrastructure
        chmod 0755 /usr/bin/pkexec     
        EOUD    
}

/**
* Virtual Server Instance for Bastion Server or Jump Server
* Element : VSI
* We are creating a bastion server or jump server along with the floating IP. The bastion server is mainly used to maintain the server and other 
* cloud resources within the same VPC. It is used to secure other servers to only allow access from bastion server. 
* For this, we will generate a ssh_key on the bastion server dynamically as part of its user data. And will use the public key contents of this 
* same generated key to create the bastion-ssh-key on IBM Cloud. And this bastion-ssh-key will be attached to all other VSI. 
* This will ensure the server access only from the Bastion.
* As this bastion server is very important to access other VSI. So to prevent the accidental 
* deletion of this server we are adding a lifecycle block with prevent_destroy=true flag to 
* protect this. If you want to delete this server then before executing terraform destroy, please update prevent_destroy=false.
**/

resource "ibm_is_instance" "bastion" {
  name           = "${var.prefix}bastion-vsi"
  keys           = var.user_ssh_key
  image          = var.bastion_image
  profile        = var.bastion_profile
  resource_group = var.resource_group_name
  vpc            = var.vpc_id
  zone           = var.zone
  user_data      = local.lin_user_data

  primary_network_interface {
    subnet          = ibm_is_subnet.bastion_sub.id
    security_groups = [ibm_is_security_group.bastion.id]
  }
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      user_data,
    ]
  }
}

/**
* Floating IP address for Bastion Server or Jump Server. This is the static public IP attached to the bastion server. User will use this floating IP to ssh connect to the 
* bastion server from their local machine.
* Element : Floating IP
* This resource will be used to attach a floating IP address.
**/

resource "ibm_is_floating_ip" "bastion_floating_ip" {
  count          = var.enable_floating_ip ? 1 : 0
  name           = "${var.prefix}bastion-fip"
  resource_group = var.resource_group_name
  target         = ibm_is_instance.bastion.primary_network_interface.0.id
  depends_on     = [ibm_is_instance.bastion]
}

/**
* This block is for time sleep once bastion server is ready. 
* Element : Wait for few seconds
**/

resource "time_sleep" "wait_240_seconds" {
  depends_on      = [ibm_is_instance.bastion, ibm_is_floating_ip.bastion_floating_ip]
  create_duration = "240s"
}


/**
* This null resource block is for deleting the dynamic ssh key generated via bastion server. This will execute on terraform destroy. 
* Element : delete_dynamic_ssh_key
* This block is for those users who has Linux/Mac as their local machines.
**/

resource "null_resource" "delete_dynamic_ssh_key" {
  triggers = {
    region          = var.region
    api_key         = var.api_key
    prefix          = var.prefix
    bastion_ssh_key = var.bastion_ssh_key
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      echo 'connection success'
      ibmcloud config --check-version=false
      i=3
      ibmcloud login -r ${self.triggers.region} --apikey ${self.triggers.api_key}
      while [ $? -ne 0 ] && [ $i -gt 0 ]; do
           i=$(( i - 1 ))
           ibmcloud login -r ${self.triggers.region} --apikey ${self.triggers.api_key}
      done      
      key_id=$(ibmcloud is keys | grep ${self.triggers.prefix}${self.triggers.bastion_ssh_key} | awk '{print $1}')
      if [ ! -z "$key_id" ]; then
          i=3
          ibmcloud is key-delete $key_id -f
          while [ $? -ne 0 ] && [ $i -gt 0 ]; do
              i=$(( i - 1 ))
              ibmcloud is key-delete $key_id -f
          done           
      fi     
      ibmcloud logout
    EOT    
  }
  depends_on = [
    ibm_is_instance.bastion,
  ]
}
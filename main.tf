/**
----------------------------------------------------------------|
* Total Resource Count for the default value of this project:   |
----------------------------------------------------------------|
* VPC Count                     = 1
* Subnet Count                  = 4
* Security Group Count          = 5
* Security Group Rules          = 17
* Load Balancers                = 2 [will incur cost]
* Load Balancer Listener        = 2
* Load Balancer Pool            = 2
* Bastion VSI                   = 1 [will incur cost]
* Instance Template             = 2
* Instance Group                = 2
* Instance Group Manager        = 2
* Instance Group Policy         = 8
* Database VSI                  = 2 [will incur cost]
* Time Sleep                    = 1
* Data Volume                   = 2 [will incur cost]
* Floating IP                   = 1 [will incur cost]
* Null Resource                 = 2
* Data Source ssh_key           = 1
* Data Source Auth Token        = 1
* Dynamic ssh_key               = 1
* placement Group               = 3
* File Share                    = 1
* Replica File share            = 1
*--------------------------------------|
*--------------------------------------|
* Total Resources               = 64   |
*--------------------------------------|
*--------------------------------------|
**/




/**
* Placement group validation for Linux/Mac Host Machine check null resource
* Element: null_resource
* This resource is used to validate the instance groups max server count and Database VSI count as per the placement group strategy provided.
**/
resource "null_resource" "placement_group_validation_check_linux" {
  provisioner "local-exec" {
    command    = <<EOT
      chmod 755 ${path.cwd}/modules/placement_group/placement_group_validation_check_linux.sh
      ./modules/placement_group/placement_group_validation_check_linux.sh ${var.web_pg_strategy} ${var.web_max_servers_count} ${var.app_pg_strategy} ${var.app_max_servers_count} ${var.db_pg_strategy} ${var.db_vsi_count}
    EOT
    on_failure = fail
  }
}


/**
* Calling the VPC module with the following required parameters
* source: Path of the Source Code of the VPC Module
* prefix: This is the prefix text that will be pre-pended in every resource name created by this module.
* resource_group_name: The resource group Name
**/
module "vpc" {
  source              = "./modules/vpc"
  prefix              = var.prefix
  resource_group_name = var.resource_group_name
  depends_on = [
    null_resource.placement_group_validation_check_linux
  ]
}

/**
* Calling the Placement Group module with the following required parameters
* source: Path of the Source Code of the Placement Group Module
* prefix: This is the prefix text that will be pre-pended in every resource name created by this module.
* resource_group_name: The resource group Name
* db_pg_strategy: The strategy for DB servers placement group - host_spread: place on different compute hosts - power_spread: place on compute hosts that use different power sources.
* web_pg_strategy: The strategy for Web servers placement group - host_spread: place on different compute hosts - power_spread: place on compute hosts that use different power sources.
* app_pg_strategy: The strategy for App servers placement group - host_spread: place on different compute hosts - power_spread: place on compute hosts that use different power sources.
**/
module "placement_group" {
  source              = "./modules/placement_group"
  prefix              = var.prefix
  resource_group_name = var.resource_group_name
  db_pg_strategy      = var.db_pg_strategy
  web_pg_strategy     = var.web_pg_strategy
  app_pg_strategy     = var.app_pg_strategy
  depends_on          = [module.vpc]
}

/**
* Data Resource
* Element : SSH Key
* This will return the ssh key id/ids of the User-ssh-key. This is the existing ssh key/keys of user which will be used to login to Bastion server.
**/
data "ibm_is_ssh_key" "ssh_key_id" {
  count = length(local.user_ssh_key_list)
  name  = local.user_ssh_key_list[count.index]
}

/**
* Calling the Bastion module with the following required parameters
* source: Source Directory of the Module
* prefix: This will be appended in resources created by this module
* enable_floating_ip: Determines whether to create Floating IP or not
* vpc_id: VPC ID to contain the subnets
* user_ssh_key: This is the name of an existing ssh key of user which will be used to login to Bastion server. Its private key content should be there in path ~/.ssh/id_rsa 
    And public key content should be uploaded to IBM cloud. If you don't have an existing key then create one using ssh-keygen -t rsa -b 4096 -C "user_ID" command.
* bastion_ssh_key: This key will be created dynamically on the bastion VSI. It will be used to login to Web/App/DB servers via Bastion.
* my_public_ip: User's Public IP address in the format X.X.X.X which will be used to login to Bastion VSI
* resource_group_name: The resource group Name
* zone: Please provide the zone name. e.g. us-south-1,us-south-2,us-south-3,us-east-1,etc. 
* api_key: Api key of user which will be used to login to IBM cloud in provisioner section
* region: Region name e.g. us-south, us-east, etc.
* bastion_profile: The Profile needed for Bastion VSI creation
* bastion_image: The Bastion Image needed for Bastion VSI creation
* bastion_ip_count: IP count is the total number of total_ipv4_address_count for Bastion Subnet
* depends_on: This ensures that the VPC object will be created before the bastion
**/
module "bastion" {
  source                 = "./modules/bastion"
  prefix                 = var.prefix
  enable_floating_ip     = local.enable_floating_ip
  vpc_id                 = module.vpc.id
  user_ssh_key           = data.ibm_is_ssh_key.ssh_key_id.*.id
  bastion_ssh_key        = var.bastion_ssh_key_var_name
  public_ip_address_list = local.public_ip_address_list
  resource_group_name    = var.resource_group_name
  zone                   = var.zone
  api_key                = var.api_key
  region                 = local.regions[var.zone]
  bastion_profile        = var.bastion_profile
  bastion_image          = var.bastion_image
  bastion_ip_count       = var.bastion_ip_count
  depends_on             = [module.vpc, module.file_share]
}

/**
* Calling the file_share module with the following required parameters
* source: Source Directory of the Module
* api_key: Api key of user which will be used to login to IBM cloud in provisioner section
* vpc_id: VPC ID to contain the subnets
* resource_group_name: The resource group Name
* zone: Please provide the zone name. e.g. us-south-1,us-south-2,us-south-3,us-east-1,etc. 
* prefix: This will be appended in resources created by this module
* region: Region name e.g. us-south, us-east, etc.
* enable_file_share: This variable will determine whether to create the file share or not.
* share_size: Specify the file share size. The value should be between 10 GB to 32000 GB's.
* share_profile: Enter the share profile value. The value should be tier-3iops, tier-5iops and tier-10iops.
* replica_zone: Availability Zone where replica file share resource will be created.
* replication_cron_spec: Enter the file share replication schedule in Linux crontab format.
* depends_on: This ensures that the VPC object will be created before the bastion
**/
module "file_share" {
  source                = "./modules/file_share"
  api_key               = var.api_key
  resource_group_name   = var.resource_group_name
  zone                  = var.zone
  prefix                = var.prefix
  vpc_id                = module.vpc.id
  region                = local.regions[var.zone]
  enable_file_share     = var.enable_file_share
  share_size            = var.share_size
  share_profile         = var.share_profile
  replica_zone          = var.replica_zone
  replication_cron_spec = var.replication_cron_spec
  depends_on            = [module.vpc]
}

/**
* Data Resource
* Element : SSH Key
* This will return the ssh key ID of the Bastion-ssh-key. This is the dynamically generated ssh key from bastion server itself.
* This key will be attached to all the app servers.
*
* Note: If you get this error on terraform apply -> Error: No SSH Key found with name {prefix}-bastion-ssh-key
* Then with terraform destroy command use -refresh=false flag at this time only.
* DO NOT use this flag on any other time, As it stops the state refresh.
* Now, before re-running the script -> Check the Bastion server image version. 
* If it is windows, It should be "Windows Server 2019 Standard Edition (amd64) ibm-windows-server-2019-full-standard-amd64-6" only.
**/
data "ibm_is_ssh_key" "bastion_key_id" {
  name = "${var.prefix}${var.bastion_ssh_key_var_name}"
  depends_on = [
    module.bastion,
  ]
}

/**
* Calling the Public Gateway module with the following required parameters
* source: Path of the Source Code of the Public Gateway Module
* vpc_id: VPC ID of region2 for the the Public Gateway Module. Public Gateways will be created inside this VPC.
* prefix: This is the prefix text that will be pre-pended in every resource name created by this module.
* resource_group_name: The resource group Name
* zone: Please provide the zone name. e.g. us-south-1, us-south-2, us-south-3, us-east-1, etc.
* depends_on: This ensures that the vpc object will be created before the Public Gateway Module
**/
module "public_gateway" {
  source              = "./modules/public_gateway"
  vpc_id              = module.vpc.id
  prefix              = "${var.prefix}region-"
  resource_group_name = var.resource_group_name
  zone                = var.zone
  depends_on          = [module.vpc]
}

/**
* Locals
* This resource will be used to create and calculate local variables containing Subnet IP count.
* If there is a requirement for extra ips please update the db_ip_count with extra required ips.
**/
locals {
  valid_ip_counts = [8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384]
  web_ip_count    = var.web_max_servers_count + 5 + 2 # 5:reservedIP, 2:load_balancer  
  app_ip_count    = var.app_max_servers_count + 5 + 2 # 5:reservedIP, 2:load_balancer      
  db_ip_count     = var.db_vsi_count + 5              # db_vsi_count:total_db_count, 5:reservedIP

  ip_count = {
    "web" = [for valid_web_ip_count in local.valid_ip_counts : valid_web_ip_count if valid_web_ip_count > local.web_ip_count][0]
    "app" = [for valid_app_ip_count in local.valid_ip_counts : valid_app_ip_count if valid_app_ip_count > local.app_ip_count][0]
    "db"  = [for valid_db_ip_count in local.valid_ip_counts : valid_db_ip_count if valid_db_ip_count > local.db_ip_count][0]
  }
}

/**
* Calling the Subnet module with the following required parameters
* source: Path of the Source Code of the Subnet Module
* vpc_id: VPC ID for the the Subnet Module. Subnets will be created inside this VPC.
* prefix: This is the prefix text that will be pre-pended in every resource name created by this module.
* resource_group_name: The resource group Name
* zone: Please provide the zone name. e.g. us-south-1,us-south-2,us-south-3,us-east-1,etc.
* ip_count: Total number of IP Address for each subnet
* public_gateway_id: Public Gateway ID where subnets will get attached
* depends_on: This ensures that the vpc object will be created before the Subnet Module
**/
module "subnet" {
  source              = "./modules/subnet"
  vpc_id              = module.vpc.id
  prefix              = var.prefix
  resource_group_name = var.resource_group_name
  zone                = var.zone
  ip_count            = local.ip_count
  public_gateway_id   = module.public_gateway.pg_id
  depends_on          = [module.vpc]
}

/**
* Calling the Security Group module with the following required parameters
* source: Source Directory of the Module
* vpc_id: VPC ID to contain the subnets
* prefix: This will be appended in resources created by this module
* resource_group_name: The resource group Name
* my_public_ip: User's Public IP address which will be used to login to Bastion VSI from their local machine
* alb_port: This is the Application load balancer listener port
* depends_on: This ensures that the vpc and subnet object will be created before the security groups
**/
module "security_group" {
  source              = "./modules/security_group"
  vpc_id              = module.vpc.id
  prefix              = var.prefix
  resource_group_name = var.resource_group_name
  alb_port            = local.alb_port
  wlb_port            = local.wlb_port
  bastion_sg          = module.bastion.bastion_sg
  depends_on          = [module.vpc, module.subnet]
}

/**
* Calling the Load Balancer module with the following required parameters
* source: Source Directory of the Module
* vpc_id: VPC ID to contain the subnets
* prefix: This will be appended in resources created by this module
* resource_group_name: The resource group Name
* lb_sg: load balancer security group to be attached with all the load balancers.
* subnets: We are passing the Map of subnet objects. It includes all the subnet IDs
* alb_port: This is the Application load balancer listener port
* lb_type_private: This variable will hold the Load Balancer type as private
* lb_type_public: This variable will hold the Load Balancer type as public
* lb_protocol: LBaaS protocols
* lb_algo: LBaaS backend distribution algorithm
* depends_on: This ensures that the vpc, subnet and security group object will be created before the load balancer
**/
module "load_balancer" {
  source              = "./modules/load_balancer"
  vpc_id              = module.vpc.id
  prefix              = var.prefix
  resource_group_name = var.resource_group_name
  lb_sg               = module.security_group.sg_objects["lb"].id
  subnets             = module.subnet.sub_objects
  alb_port            = local.alb_port
  wlb_port            = local.wlb_port
  lb_protocol         = local.lb_protocol
  lb_algo             = local.lb_algo
  lb_protocol_value   = local.lb_protocol_value
  lb_algo_value       = local.lb_algo_value
  app_lb_type         = local.app_lb_type
  web_lb_type         = var.web_lb_type
  depends_on          = [module.vpc, module.subnet, module.security_group]
}

/**
* Calling the Instance module with the following required parameters
* source: Source Directory of the Module
* prefix: This will be appended in resources created by this module
* vpc_id: VPC ID to contain the subnets
* ssh_key: This ssh_key got generated dynamically on the bastion server and further will be attached with all the other VSI to be connected from Bastion Server only
* resource_group_name: The resource group Name
* zone: Please provide the zone name. e.g. us-south-1,us-south-2,us-south-3,us-east-1,etc.
* iops_tier: Enter the IOPs (IOPS per GB) tier for db data volume. The possible values are 3, 5 and 10
* data_vol_size: Storage size in GB. The value should be between 10 and 2000
* db_image: Image ID to be used with DB VSI
* db_profile: Hardware configuration profile for the DB VSI
* db_vsi_count: Total Database instances that will be created in the user specified zone.
* tiered_profiles: Tiered profiles for Input/Output per seconds in GBs
* subnets: Subnet ID for the Database VSI
* db_sg: Security group ID to be attached with DB VSI
* depends_on: This ensures that the subnets, security group and bastion object will be created before the instance
**/
module "instance" {
  source                = "./modules/instance"
  prefix                = var.prefix
  vpc_id                = module.vpc.id
  ssh_key               = [data.ibm_is_ssh_key.bastion_key_id.id]
  resource_group_name   = var.resource_group_name
  zone                  = var.zone
  iops_tier             = var.iops_tier
  data_vol_size         = var.data_vol_size
  db_image              = var.db_image
  db_profile            = var.db_profile
  db_vsi_count          = var.db_vsi_count
  db_placement_group_id = module.placement_group.db_pg_id
  tiered_profiles       = local.tiered_profiles
  subnet                = module.subnet.sub_objects["db"].id
  db_sg                 = module.security_group.sg_objects["db"].id
  depends_on            = [module.subnet.ibm_is_subnet, module.security_group, module.bastion, module.placement_group]
}

/**
* Calling the Instance Group module with the following required parameters
* source: Source Directory of the Module
* vpc_id: VPC ID to contain the subnets
* prefix: This will be appended in resources created by this module
* resource_group_name: The resource group Name
* zone: Please provide the zone name. e.g. us-south-1,us-south-2,us-south-3,us-east-1,etc.
* ssh_key: This ssh_key got generated dynamically on the bastion server and further will be attached with all the other VSI to be connected from Bastion Server only
* subnets: We are passing the Map of subnet objects. It includes all the subnet IDs
* sg_objects: We are passing the Map of security group objects. It includes all the security groups IDs
* objects: This variable will contain the objects of LB, LB Pool and LB Listeners. It includes IDs of load balancer, load balancer pools and load balancer listeners.
* app_image: Image ID to be used with App VSI
* app_config: Application configuration Map
* web_image: Image ID to be used with Web VSI
* web_config: Web configuration Map
* web_max_servers_count: Maximum Web servers count for the Web Instance group
* web_min_servers_count: Minimum Web servers count for the Web Instance group
* web_cpu_threshold: Average target CPU Percent for CPU policy of Web Instance Group.
* web_aggregation_window: The aggregation window is the time period in seconds that the instance group manager monitors each instance and determines the average utilization.
* web_cooldown_time: Specify the cool down period, the number of seconds to pause further scaling actions after scaling has taken place.
* app_max_servers_count: Maximum App servers count for the App Instance group
* app_min_servers_count: Minimum App servers count for the App Instance group
* app_cpu_threshold: Average target CPU Percent for CPU policy of App Instance Group.
* app_aggregation_window: The aggregation window is the time period in seconds that the instance group manager monitors each instance and determines the average utilization.
* app_cooldown_time: Specify the cool down period, the number of seconds to pause further scaling actions after scaling has taken place.
* depends_on: This ensures that the vpc and other objects will be created before the instance group
**/
module "instance_group" {
  source                 = "./modules/instance_group"
  vpc_id                 = module.vpc.id
  prefix                 = var.prefix
  resource_group_name    = var.resource_group_name
  zone                   = var.zone
  ssh_key                = [data.ibm_is_ssh_key.bastion_key_id.id]
  subnets                = module.subnet.sub_objects
  sg_objects             = module.security_group.sg_objects
  objects                = module.load_balancer.objects
  web_placement_group_id = module.placement_group.web_pg_id
  app_placement_group_id = module.placement_group.app_pg_id
  app_image              = var.app_image
  app_instance_profile   = var.app_instance_profile
  app_config             = local.app_config
  web_image              = var.web_image
  web_config             = local.web_config
  web_instance_profile   = var.web_instance_profile
  web_max_servers_count  = var.web_max_servers_count
  web_min_servers_count  = var.web_min_servers_count
  web_cpu_threshold      = var.web_cpu_threshold
  web_aggregation_window = var.web_aggregation_window
  web_cooldown_time      = var.web_cooldown_time
  app_max_servers_count  = var.app_max_servers_count
  app_min_servers_count  = var.app_min_servers_count
  app_cpu_threshold      = var.app_cpu_threshold
  app_aggregation_window = var.app_aggregation_window
  app_cooldown_time      = var.app_cooldown_time
  enable_file_share      = var.enable_file_share
  mount_path             = module.file_share.mountPath
  depends_on             = [module.bastion, module.load_balancer, module.instance, module.placement_group, module.file_share]
}
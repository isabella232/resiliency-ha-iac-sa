/**
#################################################################################################################
*
*                               Load Balancer Section for Web Tier
*                                 Start Here for the Web LB Section 
*
#################################################################################################################
*/

/**
* Web Load Balancer
* Element : web_lb
* This resource will create the Public Web Load Balancer for Web servers
* This will balance load between all the web servers
**/
resource "ibm_is_lb" "web_lb" {
  name            = "${var.prefix}web-lb"
  resource_group  = var.resource_group_name
  type            = var.web_lb_type
  subnets         = var.subnets["web"].*.id
  security_groups = [var.lb_sg]
}

/**
* Web Load Balancer Pool
* Element : web_pool
* This resource will create the Web Load Balancer Pool
**/
resource "ibm_is_lb_pool" "web_pool" {
  lb                  = ibm_is_lb.web_lb.id
  name                = "${var.prefix}web-pool"
  protocol            = var.lb_protocol[var.lb_protocol_value]
  algorithm           = var.lb_algo[var.lb_algo_value]
  health_delay        = "5"
  health_retries      = "2"
  health_timeout      = "2"
  health_type         = var.lb_protocol[var.lb_protocol_value]
  health_monitor_url  = "/"
  health_monitor_port = var.wlb_port
  depends_on          = [ibm_is_lb.web_lb]

}

/**
* Web Load Balancer Listener
* Element : web_listener
* This resource will create the Web Load Balancer Listener
**/
resource "ibm_is_lb_listener" "web_listener" {
  lb           = ibm_is_lb.web_lb.id
  protocol     = var.lb_protocol[var.lb_protocol_value]
  port         = var.wlb_port
  default_pool = ibm_is_lb_pool.web_pool.pool_id
  depends_on   = [ibm_is_lb.web_lb, ibm_is_lb_pool.web_pool]
}


# /**               
# #################################################################################################################
# *                              End of the Web Load Balancer Section 
# #################################################################################################################
# **/


###################################################################################################
###################################################################################################
#####         This Terraform file defines the variables used in Load Balancer Module         ######
#####                                     Load Balancer Module                               ######
###################################################################################################
###################################################################################################


/**
* Name: lb_protocol, lb_algo, lb_protocol_value & lb_algo_value
* Type: map(any)
* Description: LBaaS Protocols & LBaaS backend distribution algorithm
**/
locals { // put on top
  lb_protocol = {
    "http"  = "http"
    "https" = "https"
    "tcp"   = "tcp"
  }
  lb_algo = {
    "round_robin"          = "round_robin"
    "weighted_round_robin" = "weighted_round_robin"
    "least_connections"    = "least_connections"
  }

  app_lb_type       = "private"     #This local variable will hold the App Load Balancer type as private
  lb_protocol_value = "http"        #LBaaS Protocols. The protocol could be any of these values: http, https, tcp. Default Value: http
  lb_algo_value     = "round_robin" #LBaaS backend distribution algorithm. The algorithm could be any of the values: round_robin, weighted_round_robin, least_connections. Default Value: round_robin
}


/**
* Name: web_lb_type
* Desc: This variable will hold the Load Balancer type as public
* Type: String
**/
variable "web_lb_type" {
  description = "Determine if a public or private 3-tier application. Valid value public or private."
  type        = string
  default     = "public"
}

/**               
#################################################################################################################
*                                   End of the Variable Section 
#################################################################################################################
**/


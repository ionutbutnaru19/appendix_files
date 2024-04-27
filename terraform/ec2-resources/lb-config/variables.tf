variable "lb_name" {
  description = "The name of the load balancer"
  type        = string
}


variable "subnets" {
  description = "The list of subnets in which the load balancer will be deployed"
  type        = list(string)
}

variable "security_groups" {
  description = "The list of security groups associated with the load balancer"
  type        = list(string)
}

variable "vpc_id" {
  type = string
}

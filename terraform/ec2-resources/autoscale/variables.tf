variable "launch_config" {
 type = string
}

variable "subnets" {
 type = list(string)
}

variable "target_group" {
 type = list(string)
}

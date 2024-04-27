variable "security_groups" {
  type = list(string)
}

variable "key_name" {
 type = string
}

variable "instance_type" {
  default = "t2.micro"
}


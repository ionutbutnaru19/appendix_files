variable "instance_type" {
 default = "t2.micro"
}

variable "vpc_id" {
 type = string
}

variable "subnet_id" {
 type = string
}

variable "instance_name" {
 type = string
}

variable "security_group_id" {
 type = string
}

variable "key_name" {
 type = string
}

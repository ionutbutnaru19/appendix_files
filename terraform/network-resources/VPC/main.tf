resource "aws_vpc" "deployment_vpc" {
  cidr_block = "10.50.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

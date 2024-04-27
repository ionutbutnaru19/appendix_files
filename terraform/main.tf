module "webapp_VPC" {
  # Module for deploying the Virtual Private Cloud (VPC) for the web application
  source = "./network-resources/VPC"
  vpc_name = "webApp_VPC"
}

module "subnetting" {
  # Module for configuring subnets and routing within the VPC
  source = "./network-resources/SUBNETS"
  vpc_id = module.webapp_VPC.vpc_ID
}

module "external_access" {
  # Module for creating a security group allowing only SSH traffic
  source = "./security-resources"
  vpc_id = module.webapp_VPC.vpc_ID
  sg_name = "Only SSH"
}

module "passcode_key" {
  # Module for creating an access key secured with a passcode for connecting to Primary and Failover servers
  source = "./ec2-resources/keypair"
  key_name = "bastionKEY"
  public_key = file("~/bastionKEY.pub")
  vpc_id = module.webapp_VPC.vpc_ID
}

module "Primary_Bastion" {
  # Module for deploying the main server to connect to the instances from public subnets
  source = "./ec2-resources/server_config"
  vpc_id = module.webapp_VPC.vpc_ID
  security_group_id = module.external_access.ssh
  subnet_id = module.subnetting.public_A_subnet_id
  instance_name = "Primary_Bastion"
  key_name = module.passcode_key.key_pair_name
}

module "Failover_Bastion" {
  # Module for deploying the failover server in case of primary server being inaccessible (in a different Availability Zone)
  source = "./ec2-resources/server_config"
  vpc_id = module.webapp_VPC.vpc_ID
  security_group_id = module.external_access.ssh
  subnet_id = module.subnetting.public_B_subnet_id
  instance_name = "Failover_Bastion"
  key_name = module.passcode_key.key_pair_name
}

resource "aws_security_group" "Custom_SG" {
  # Custom security group for restricted access to internal resources
  name = "Custom SG"
  vpc_id = module.webapp_VPC.vpc_ID

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [module.external_access.ssh]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    security_groups = [module.external_access.ssh]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "HTTP, SSH and ICMP"
  } 
}

module "load_balancer" {
  # Module for configuring the load balancer
  source = "./ec2-resources/lb-config"
  vpc_id = module.webapp_VPC.vpc_ID
  lb_name = "Webapp-LB"
  subnets = [module.subnetting.public_A_subnet_id, module.subnetting.public_B_subnet_id]
  security_groups = [aws_security_group.Custom_SG.id]
}

module "launch_cf" {
  # Module for configuration of the webservers
  source = "./ec2-resources/launch-config"
  key_name = module.webservers_key.key_pair_name
  security_groups = [aws_security_group.Custom_SG.id]
}

module "autoscale" {
  # Module for configuring autoscaling of the webservers
  source = "./ec2-resources/autoscale"
  launch_config = module.launch_cf.instance_launch
  subnets = [module.subnetting.private_A_subnet_id, module.subnetting.private_B_subnet_id]
  target_group = [module.load_balancer.target_group_id]
}

module "webservers_key" {
  # Module for creating a key pair for accessing the web servers
  source = "./ec2-resources/keypair"
  key_name = "webserverKEY"
  public_key = file("~/webserverKEY.pub")
  vpc_id = module.webapp_VPC.vpc_ID
}

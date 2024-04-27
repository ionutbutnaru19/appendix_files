data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name  = "name"
    values = ["al2023-ami-*-kernel-*-x86_64"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_launch_configuration" "webserver_launch_configuration" {
  name = "webservers-configuration"
  image_id = data.aws_ami.latest_amazon_linux.id  
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = var.security_groups
  user_data = <<-EOF
                #!/bin/bash
                sudo dnf -y update
                sudo dnf install -y httpd php git
                sudo systemctl enable httpd
                sudo systemctl start httpd
                sudo git clone https://github.com/ionutbutnaru19/projectdeploy.git /var/www/html/
                EOF
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
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

resource "aws_instance" "server_config" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.security_group_id] 
  subnet_id = var.subnet_id
  key_name = var.key_name
  tags = {
    Name = var.instance_name
  }
  user_data = <<-EOF
                #!/bin/bash
                sudo dnf -y update
                sudo dnf install -y ansible nano
                EOF
}

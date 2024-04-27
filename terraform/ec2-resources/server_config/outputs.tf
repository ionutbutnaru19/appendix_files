output "public_ip" {
  value = aws_instance.server_config.public_ip
}

output "private_ip" {
  value = aws_instance.server_config.private_ip
}

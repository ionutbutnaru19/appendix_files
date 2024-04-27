output "public_A_subnet_id" {
  value = aws_subnet.public_A.id
}
output "public_B_subnet_id" {
  value = aws_subnet.public_B.id
}

output "private_A_subnet_id" {
  value = aws_subnet.private_A.id
}
output "private_B_subnet_id" {
  value = aws_subnet.private_B.id
}

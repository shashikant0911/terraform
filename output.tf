output "public_subnet_0" {
  value = aws_subnet.public_subnet[0].id
}

output "public_subnet_1" {
  value = aws_subnet.public_subnet[1].id
}

output "public_subnet_2" {
  value = aws_subnet.public_subnet[2].id
}

output "aws_sg_api" {
  value = aws_security_group.irs-api.id
}

output "aws_sg_admin" {
  value = aws_security_group.irs-admin.id
}

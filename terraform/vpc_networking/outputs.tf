output "front_security_group" {
  value = aws_security_group.cookbook_frontend_sg.id
}

output "back_security_group" {
  value = aws_security_group.cookbook_backend_sg.id
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}

output "cookbook_vpc_id" {
  value = aws_vpc.main.id
}

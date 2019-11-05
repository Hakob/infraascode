output "front_ips" {
  value = aws_instance.front_instances.*.public_ip
}

output "back_ips" {
  value = aws_instance.back_instances.*.public_ip
}

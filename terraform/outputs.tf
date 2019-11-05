output "front-ips" {
  value = module.ec2_instance.front_ips
}

output "back-ips" {
  value = module.ec2_instance.back_ips
}

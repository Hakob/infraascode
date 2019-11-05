output "alb_id" {
  value = aws_alb.cookbook.dns_name  # or public_dns
}

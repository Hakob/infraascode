provider "aws" {
  region = "${var.region}"
}

resource "aws_alb" "cookbook" {
  name               = "cookbook-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.front_sg}"]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Environment = "cookbook"
  }
}

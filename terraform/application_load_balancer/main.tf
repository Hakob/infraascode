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

resource "aws_alb_target_group" "cb_target_group" {
  name     = "cookbook-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.cb_vpc_id}"

}

resource "aws_alb_listener" "cb_alb_listener" {
  load_balancer_arn = "${aws_alb.cookbook.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.cb_target_group.arn}"
    type             = "forward"
  }
}

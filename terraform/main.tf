module "vpc_networking" {
  source         = "./vpc_networking"
  region         = "${var.region}"
  vpc_cidr       = "${var.vpc_cidr}"
  public_cidrs   = "${var.public_cidrs}"
  private_cidrs  = "${var.private_cidrs}"
  instance_count = "${var.instance_count}"
}

module "ec2_instance" {
  source         = "./ec2_instance"
  region         = "${var.region}"
  privkey_path   = "${var.privkey_path}"
  pubkey_path    = "${var.pubkey_path}"
  instance_type  = "${var.instance_type}"
  instance_count = "${var.instance_count}"
  front_sg       = "${module.vpc_networking.front_security_group}"
  back_sg        = "${module.vpc_networking.back_security_group}"
  subnet_ids     = "${module.vpc_networking.public_subnets}"
}

module "application_load_balancer" {
  source     = "./application_load_balancer"
  region     = "${var.region}"
  front_sg   = "${module.vpc_networking.front_security_group}"
  subnet_ids = "${module.vpc_networking.public_subnets}"
}

variable "region" {}

variable "vpc_cidr" {}

variable "public_cidrs" {
  type = "list"
}

variable "private_cidrs" {
  type = "list"
}
variable "privkey_path" {}
variable "pubkey_path" {}
variable "instance_type" {}
variable "instance_count" {}

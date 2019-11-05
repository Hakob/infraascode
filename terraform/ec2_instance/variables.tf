variable "region" {}
variable "privkey_path" {}
variable "pubkey_path" {}
variable "instance_type" {}
variable "instance_count" {}
variable "front_sg" {}
variable "back_sg" {}
variable "subnet_ids" {
  type = "list"
}
variable "device_name" {
  default = "/dev/xvdh"
}

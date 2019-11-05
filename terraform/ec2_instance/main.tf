provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "available" {}

data "aws_ami" "centos" {
  owners      = ["aws-marketplace"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_key_pair" "cookbook_key" {
  key_name   = "cookbook_terraform_key"
  public_key = "${file(var.pubkey_path)}"
}

resource "aws_instance" "front_instances" {
  count                  = "${var.instance_count}"
  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${aws_key_pair.cookbook_key.id}"
  vpc_security_group_ids = ["${var.front_sg}"]
  subnet_id              = "${element(var.subnet_ids, count.index)}"
  user_data              = "${data.template_file.user-init.rendered}"

  connection {
    private_key = "${file(var.privkey_path)}"
    host        = "${self.public_ip}"
    user        = "centos"
    type        = "ssh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum -qq install python -y"
      ]
  }

  provisioner "local-exec" {
    working_dir = "../ansible/"
    command     = <<EOT
      if [ -f "frontend.ini" ]; then
        echo "${self.public_ip}" | tee -a frontend.ini
      else 
        >frontend.ini;
        echo "[front]" | tee -a frontend.ini;
        echo "${self.public_ip}" | tee -a frontend.ini
      fi
    	EOT
  }

  tags = {
    Name = "FrontEnd.${count.index + 1}"
  }
}

resource "aws_instance" "back_instances" {
  count                  = "${var.instance_count}"
  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${aws_key_pair.cookbook_key.id}"
  vpc_security_group_ids = ["${var.back_sg}"]
  subnet_id              = "${element(var.subnet_ids, count.index)}"
  user_data              = "${data.template_file.user-init.rendered}"

  connection {
    private_key = "${file(var.privkey_path)}"
    host        = "${self.public_ip}"
    user        = "centos"
    type        = "ssh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum -qq install python -y"
    ]
  }

  provisioner "local-exec" {
    working_dir = "../ansible/"
    command     = <<EOT
      if [ -f "backend.ini" ]; then
        echo "${self.public_ip}" | tee -a backend.ini
      else 
        >backend.ini;
        echo "[back]" | tee -a backend.ini;
        echo "${self.public_ip}" | tee -a backend.ini
      fi
    	EOT
  }

  tags = {
    Name = "BackEnd.${count.index + 1}"
  }
}

resource "aws_ebs_volume" "front_ebs" {
  count             = "${var.instance_count}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  size              = 5
  type              = "gp2"
}

resource "aws_volume_attachment" "front_ebs_attachment" {
  count       = "${var.instance_count}"
  device_name = "${var.device_name}"
  instance_id = "${aws_instance.front_instances.*.id[count.index]}"
  volume_id   = "${aws_ebs_volume.front_ebs.*.id[count.index]}"
}

resource "aws_ebs_volume" "back_ebs" {
  count             = "${var.instance_count}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  size              = 5
  type              = "gp2"
}

resource "aws_volume_attachment" "back_ebs_attachment" {
  count       = "${var.instance_count}"
  device_name = "${var.device_name}"
  instance_id = "${aws_instance.back_instances.*.id[count.index]}"
  volume_id   = "${aws_ebs_volume.back_ebs.*.id[count.index]}"
}
data "template_file" "user-init" {
  template = "${file("${path.module}/userdata.tpl")}"
}

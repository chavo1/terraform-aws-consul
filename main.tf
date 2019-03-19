terraform {
  required_version = ">= 0.11.5"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "consul" {
  name_prefix        = "${var.name}-"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

data "aws_iam_policy_document" "consul" {
  statement {
    sid       = "AllowSelfAssembly"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "ec2:DescribeVpcs",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
    ]
  }
}

resource "aws_iam_role_policy" "consul" {
  name_prefix = "${var.name}-"
  role        = "${aws_iam_role.consul.id}"
  policy      = "${data.aws_iam_policy_document.consul.json}"
}

resource "aws_iam_instance_profile" "consul" {
  name_prefix = "${var.name}-"
  role        = "${aws_iam_role.consul.name}"
}

resource "aws_instance" "server" {
  ami                         = "${var.ami["server"]}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  count                       = "${var.server_count}"
  private_ip                  = "172.31.16.${count.index + 11}"
  subnet_id                   = "${var.subnet}"
  iam_instance_profile        = "${aws_iam_instance_profile.consul.id}"
  associate_public_ip_address = true

  tags {
    Name   = "consul-server0${count.index + 1}"
    consul = "app"
  }

  connection {
    user        = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source      = "scripts/consul.sh"
    destination = "/tmp/consul.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo bash /tmp/consul.sh",
    ]
  }
}

resource "aws_instance" "client" {
  ami                         = "${var.ami["client"]}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  count                       = "${var.client_count}"
  private_ip                  = "172.31.16.${count.index + 21}"
  subnet_id                   = "${var.subnet}"
  iam_instance_profile        = "${aws_iam_instance_profile.consul.id}"
  associate_public_ip_address = true
  depends_on                  = ["aws_instance.server"]

  tags {
    Name   = "consul-client0${count.index + 1}"
    consul = "app"
  }

  connection {
    user        = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source      = "scripts/"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo bash /tmp/consul.sh",
      "sudo bash /tmp/kv.sh",
      "sudo bash /tmp/consul-template.sh",
      "sudo bash /tmp/nginx.sh",
      "sudo bash /tmp/dns.sh",
    ]
  }
}

output "public_dns_servers" {
  value = "${aws_instance.server.*.public_dns}"
}

output "public_dns_clients" {
  value = "${aws_instance.client.*.public_dns}"
}

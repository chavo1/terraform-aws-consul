terraform {
  required_version = ">= 0.11.5"
}

// We need an AWS credentials
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

// Generates an IAM policy document in JSON format
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

// Lets creates an IAM Role and Instance Profile with a necessary permission required for Consul Auto-Join
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

// Generates an IAM policy document in JSON format
resource "aws_iam_role_policy" "consul" {
  name_prefix = "${var.name}-"
  role        = "${aws_iam_role.consul.id}"
  policy      = "${data.aws_iam_policy_document.consul.json}"
}

// This will provides an IAM instance profile.
resource "aws_iam_instance_profile" "consul" {
  name_prefix = "${var.name}-"
  role        = "${aws_iam_role.consul.name}"
}

// Here we create the Consul servers
resource "aws_instance" "server" {
  ami                         = "${var.ami["server"]}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  count                       = "${var.server_count}"
  private_ip                  = "172.31.${var.dc_net}.${count.index + 11}"
  subnet_id                   = "${var.subnet}"
  iam_instance_profile        = "${aws_iam_instance_profile.consul.id}"
  associate_public_ip_address = true

  // Consul tag consul = "app" we need it for AWS Consul Auto-Join
  tags {
    Name       = "consul-server0${count.index + 1}"
    consul     = "app"
    consul_wan = "wan_app"
  }

  // Our private key needed for connection to the servers 
  connection {
    user        = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/consul.sh"
    destination = "/tmp/consul.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${var.dcname}",
      "sudo bash /tmp/consul.sh ${var.dcname}",
    ]
  }
}

// Here we create the Consul clients
resource "aws_instance" "client" {
  ami                         = "${var.ami["client"]}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  count                       = "${var.client_count}"
  private_ip                  = "172.31.${var.dc_net}.${count.index + 21}"
  subnet_id                   = "${var.subnet}"
  iam_instance_profile        = "${aws_iam_instance_profile.consul.id}"
  associate_public_ip_address = true
  depends_on                  = ["aws_instance.server"]

  // consul tag consul = "app" is important for AWS Consul Auto-Join
  tags {
    Name       = "consul-client0${count.index + 1}"
    consul     = "app"
    consul_wan = "wan_app"
  }

  // Our private key needed for connection to the clients 
  connection {
    user        = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  // Copying needed scripts on the instance 
  provisioner "file" {
    source      = "${path.module}/scripts/"
    destination = "/tmp/"
  }

  // This is our provisioning scripts
  provisioner "remote-exec" {
    inline = [
      "echo ${var.dcname}",
      "sudo bash /tmp/consul.sh ${var.dcname}",
      "sudo bash /tmp/kv.sh",
      "sudo bash /tmp/consul-template.sh",
      "sudo bash /tmp/nginx.sh",
      "sudo bash /tmp/dns.sh",
    ]
  }
}

// The output of the consul agents
output "public_dns_servers" {
  value = "${aws_instance.server.*.public_dns}"
}

output "public_dns_clients" {
  value = "${aws_instance.client.*.public_dns}"
}

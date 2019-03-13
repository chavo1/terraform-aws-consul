provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "server" {
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  count                       = 3
  private_ip                  = "172.31.16.${count.index + 11}"
  subnet_id                   = "${var.subnet}"
  associate_public_ip_address = true

  tags {
    Name = "consul-server0${count.index + 1}"
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
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  count                       = 2
  private_ip                  = "172.31.16.${count.index + 21}"
  subnet_id                   = "${var.subnet}"
  associate_public_ip_address = true

  tags {
    Name = "consul-client0${count.index + 1}"
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
      "sudo apt-get update -y",
      "sudo bash /tmp/consul.sh",
      "sudo bash /tmp/kv.sh",
      "sudo bash /tmp/nginx.sh",
    ]
  }
}

output "public_dns_servers" {
  value = "${aws_instance.server.*.public_dns}"
}

output "public_dns_clients" {
  value = "${aws_instance.client.*.public_dns}"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "server" {
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  count                       = 2
  private_ip                  = "172.31.16.1${count.index + 1}"
  subnet_id                   = "${var.subnet}"
  associate_public_ip_address = true

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
      "sudo chmod +x /tmp/consul.sh",
      "sudo /tmp/consul.sh",
    ]
  }
}

output "public_dns" {
  value = "${aws_instance.server.*.public_dns}"
}

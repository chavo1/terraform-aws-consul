module "consul-terraform" {
  source = "github.com/chavo1/terraform-aws-consul"

  access_key    = "${var.access_key}"
  secret_key    = "${var.secret_key}"
  region        = "${var.region}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  subnet        = "${var.subnet}"
  client_count  = "${var.client_count}"
  server_count  = "${var.server_count}"
}

output "public_dns_servers" {
  value = "${module.consul-terraform.public_dns_servers}"
}

output "public_dns_clients" {
  value = "${module.consul-terraform.public_dns_clients}"
}

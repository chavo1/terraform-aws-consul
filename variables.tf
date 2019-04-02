variable "access_key" {}
variable "secret_key" {}

variable "subnet" {
  type    = "list"
  default = []
}

variable "instance_type" {}
variable "key_name" {}
variable "client_count" {}
variable "server_count" {}
variable "dc_net" {}

// This is our server and client AMIs - we build with Packer for example and more info
// https://github.com/chavo1/packer-consul-client
// https://github.com/chavo1/packer-consul-server

variable "ami" {
  type = "map"

  default = {
    client = "ami-0c07b172e2210f10d"
    server = "ami-0e407afb422953a9e"
  }
}

variable "region" {
  default = "us-east-1"
}

variable "create" {
  description = "Create Module, defaults to true."
  default     = true
}

variable "name" {
  description = "Name for resources, defaults to \"consul-auto-join-instance-role-aws\"."
  default     = "consul-auto-join-aws"
}

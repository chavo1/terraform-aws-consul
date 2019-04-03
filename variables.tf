variable "access_key" {}
variable "secret_key" {}
variable "subnet" {}
variable "instance_type" {}
variable "key_name" {}
variable "client_count" {}
variable "server_count" {}
variable "dc_net" {}
variable "dcname" {}

// This is our server and client AMIs - we build with Packer for example and more info
// https://github.com/chavo1/packer-consul-client
// https://github.com/chavo1/packer-consul-server

variable "ami" {
  type = "map"

  default = {
    client = "ami-023d06001e0e56264"
    server = "ami-00e9cbd23a90befc8"
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

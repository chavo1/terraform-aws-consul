variable "access_key" {}
variable "secret_key" {}

variable "subnet" {
  type    = "list"
  default = []
}

variable "dcname" {
  type    = "map"
  default = {}
}

variable "instance_type" {}
variable "key_name" {}
variable "client_count" {}
variable "server_count" {}

variable "dc_net" {
  type = "map"

  default = {
    dc1 = "16"
    dc2 = "32"
  }
}

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

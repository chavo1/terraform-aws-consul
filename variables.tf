variable "access_key" {}
variable "secret_key" {}
variable "subnet" {}
variable "instance_type" {}
variable "key_name" {}

variable "ami" {
  type = "map"

  default = {
    client = "ami-06e53b23dfe5d38d3"
    server = "ami-0c2073f0a75d77a95"
  }
}

variable "region" {
  default = "us-east-1"
}

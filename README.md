## TODO

### v0.2
- [x] THIS README

### v0.3
- [x] build with packer-kitchen test - server and client ami
[PACKER-SERVER](https://github.com/chavo1/packer-consul-server)
[PACKER-CLIENT](https://github.com/chavo1/packer-consul-client)

- [x] update code to use our own ami

# This repo contains a demo of [Consul](https://www.consul.io/) cluster in AWS over HTTP as a systemd daemon service.

## Prerequisites

- Please install the following components:

  - | [Terraform](https://www.terraform.io/)

You must also have an AWS account. You will need to set up your AWS credentials and needed variables in "example.tfvars" file. 

### We are now ready to go.
```
git clone https://github.com/chavo1/consul-terraform.git
cd consul consul-terraform 
```
- Create a terraform.tfvars file with following content:
```
access_key = "< Your AWS Access_key >"
secret_key = "< Your AWS Secret_key >"
key_name = ""
region = ""
instance_type = ""
subnet = "< VPC subnet ID >"
```

### We can start with deploying process
```
cd ../ # go back to consul-terraform
terraform init
terraform plan
terraform apply
```
### Do not forget to destroy the environment after the test
```
terraform destroy
```


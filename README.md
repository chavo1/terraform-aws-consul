## TODO

### v0.2
- [x] THIS README

### v0.3
- [x] build with packer-kitchen test - server and client ami

- [x] update code to use our own ami

# This repo contains a demo of Consul cluster in AWS over HTTP as a systemd daemon service.

## Prerequisites

Please install the following components:

  [Packer](https://www.packer.io/)
  [Terraform](https://www.terraform.io/)
  [KitchenCI](https://kitchen.ci/)

You must also have an AWS account. You will need to set up your AWS credentials and needed variables in "example.tfvars" file. 

### We are now ready to go.
```
git clone https://github.com/chavo1/consul-terraform.git
cd consul consul-terraform/packer
sudo packer build xenial.json # this will build a custom AMI with consul. 
```
Please check the readme in packer directory. 
Fill the AMI ID in example.tfvars file.

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


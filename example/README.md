# This example contains a demo of [Consul](https://www.consul.io/) cluster in AWS over HTTP as a systemd daemon service.

## Prerequisites

- Please install the following component:

  - | [Terraform](https://www.terraform.io/)

You must also have an AWS account. You will need to set up your AWS credentials and needed variables in "example.tfvars" file. 

### We are now ready to go.
```
git clone git clone git@github.com:chavo1/terraform-aws-consul.git
cd consul terraform-aws-consul/example
```
- Create a terraform.tfvars file with following content:
```
access_key = "< Your AWS Access_key >"
secret_key = "< Your AWS Secret_key >"
key_name = ""
region = ""
instance_type = ""
subnet = "< VPC subnet ID >"
client_count = 1
server_count = 1
```

### We can start with deploying process
```
terraform init
terraform plan
terraform apply
```
### Do not forget to destroy the environment after the test
```
terraform destroy
```

### To test the module you will need Kitchen:

Kitchen is a RubyGem so please find how to install and setup Test Kitchen, check out the [Getting Started Guide](http://kitchen.ci/docs/getting-started/).
For more information about kitchen tests please check the next link:

https://kitchen.ci/docs/getting-started/running-test/

Than simply execute a following commands:
```
kitchen converge
kitchen verify
kitchen destroy
```
- The output from the test for 1 Consul server and 1 Consul client should as follow
```
  Command: `terraform state list`
     ✔  stdout should eq "module.consul-terraform.aws_instance.client\nmodule.consul-terraform.aws_instance.server\n"
     ✔  stderr should eq ""
     ✔  exit_status should eq 0

Test Summary: 3 successful, 0 failures, 0 skipped
       Finished verifying <default-terraform> (0m0.40s).```

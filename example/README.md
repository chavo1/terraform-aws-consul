# This example contains a demo of [Consul](https://www.consul.io/) cluster in AWS over HTTP as a systemd daemon service.
## Joining of the consul agent could be done with:
- Cloud Auto-joining more info [HERE](https://www.consul.io/docs/agent/cloud-auto-join.html) and examples [HERE](https://github.com/hashicorp-modules/consul-auto-join-instance-role-aws)
  - | iam_instance_profile](https://www.terraform.io/docs/providers/aws/r/instance.html#iam_instance_profile)
- [-retry-join](https://www.consul.io/docs/agent/options.html#_retry_join)
## Prerequisites
- Please install the following component:
  - | [Terraform](https://www.terraform.io/)
- You must also have an AWS account. 
- Clone the repo:
```
git clone git clone git@github.com:chavo1/terraform-aws-consul.git
cd consul terraform-aws-consul/example
```
- Create terraform.tfvars file with needed credential and variables:
```
access_key = "< Your AWS Access_key >"
secret_key = "< Your AWS Secret_key >"
key_name = ""
region = "us-east-1"
instance_type = ""
subnet = "< VPC subnet ID >"
client_count = 2
server_count = 2
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
- Kitchen-Terraform tests are for 2 Consul servers and 2 Consul clients and should be as follow:
```
Command: `terraform state list`
     ✔  stdout should include "module.consul-terraform.aws_instance.client[0]"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform state list`
     ✔  stdout should include "module.consul-terraform.aws_instance.server[0]"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform state list`
     ✔  stdout should include "module.consul-terraform.aws_instance.client[1]"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform state list`
     ✔  stdout should include "module.consul-terraform.aws_instance.server[1]"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  http GET on http://ec2-3-95-55-225.compute-1.amazonaws.com:80
     ✔  status should cmp == 200
  http GET on http://ec2-3-95-55-225.compute-1.amazonaws.com:8500/ui/dc1/nodes
     ✔  status should cmp == 200
  http GET on http://ec2-3-95-55-225.compute-1.amazonaws.com:8500/ui/dc1/services/web
     ✔  status should cmp == 200
  http GET on http://ec2-3-91-31-87.compute-1.amazonaws.com:8500/ui/dc1/nodes
     ✔  status should cmp == 200
  http GET on http://ec2-3-91-31-87.compute-1.amazonaws.com:8500/ui/dc1/services/web
     ✔  status should cmp == 200
  http GET on http://ec2-54-237-203-75.compute-1.amazonaws.com:80
     ✔  status should cmp == 200
  http GET on http://ec2-54-237-203-75.compute-1.amazonaws.com:8500/ui/dc1/nodes
     ✔  status should cmp == 200
  http GET on http://ec2-54-237-203-75.compute-1.amazonaws.com:8500/ui/dc1/services/web
     ✔  status should cmp == 200
  http GET on http://ec2-3-80-99-67.compute-1.amazonaws.com:8500/ui/dc1/nodes
     ✔  status should cmp == 200
  http GET on http://ec2-3-80-99-67.compute-1.amazonaws.com:8500/ui/dc1/services/web
     ✔  status should cmp == 200

Test Summary: 22 successful, 0 failures, 0 skipped
```

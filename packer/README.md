# Usage example:

## This will build an AWS AMI with consul installed. If you need a specific version of [Consul](https://www.consul.io/). 
- Please change it into "provision.sh" script:
```
CONSUL=1.4.3
```
- Export you AWS keys:
```
export AWS_ACCESS_KEY_ID=MYACCESSKEYID
export AWS_SECRET_ACCESS_KEY=MYSECRETACCESSKEY
```
- From your CLI execute a following command:

```
sudo packer build xenial.json
``` 
For more info please check a following link:

https://www.packer.io/intro/getting-started/build-image.html#some-more-examples-

To test you will need Kitchen:

Kitchen is a RubyGem so please find how to install and setup Test Kitchen for developing infrastructure code, check out the [Getting Started Guide](http://kitchen.ci/docs/getting-started/).

A following [gems](https://guides.rubygems.org/what-is-a-gem/) should be installed:

```
gem install  kitchen-vagrant
gem install  kitchen-inspec
```
Than simply execute a following commands:

```
kitchen converge
kitchen verify
kitchen destroy
```
The result should be as follow
``` 
✔  operating_system: Command: `lsb_release -a`
     ✔  Command: `lsb_release -a` stdout should match /Ubuntu/

  File /usr/local/bin/consul
     ✔  should exist
  File /etc/systemd/system/consul.service
     ✔  should exist

Profile Summary: 1 successful control, 0 control failures, 0 controls skipped
Test Summary: 3 successful, 0 failures, 0 skipped
```
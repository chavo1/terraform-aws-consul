describe command('terraform state list') do
  its('stdout') { should include "module.consul-terraform.aws_instance.client[0]" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform state list') do
  its('stdout') { should include "module.consul-terraform.aws_instance.server[0]" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform state list') do
  its('stdout') { should include "module.consul-terraform.aws_instance.client[1]" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform state list') do
  its('stdout') { should include "module.consul-terraform.aws_instance.server[1]" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end

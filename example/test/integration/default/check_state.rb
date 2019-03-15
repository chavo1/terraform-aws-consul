describe command('terraform state list') do
  its('stdout') { should eq "module.consul-terraform.aws_instance.client\nmodule.consul-terraform.aws_instance.server\n" }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

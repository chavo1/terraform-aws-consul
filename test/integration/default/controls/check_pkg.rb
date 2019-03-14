describe file("/usr/local/bin/consul") do
  it { should exist } # the binary file should exist
end
describe file("/etc/systemd/system/consul.service") do
  it { should exist } # the configuration file should exist
end



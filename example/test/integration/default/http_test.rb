public_dns_clients = attribute(
  "public_dns_clients",
  description: "client dns"
)
public_dns_servers = attribute(
  "public_dns_servers",
  description: "server dns"
)

0.upto(1) do |n|
  describe http("http://#{public_dns_clients[n]}:80") do
    its('status') { should cmp 200 }
  end
  describe http("http://#{public_dns_clients[n]}:8500/ui/dc1/nodes") do
    its('status') { should cmp 200 }
  end
  describe http("http://#{public_dns_clients[n]}:8500/ui/dc1/services/web") do
    its('status') { should cmp 200 }
  end
  describe http("http://#{public_dns_servers[n]}:8500/ui/dc1/nodes") do
    its('status') { should cmp 200 }
  end
  describe http("http://#{public_dns_servers[n]}:8500/ui/dc1/services/web") do
    its('status') { should cmp 200 }
  end
end
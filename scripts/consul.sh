#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
SERVER_COUNT=1
CLIENT_COUNT=0
CONSUL_VERSION=1.4.3
IPs=$(hostname -I)
HOST=$(hostname)

# Install packages
which unzip jq dnsutils vim curl &>/dev/null || {
sudo apt-get update -y
sudo apt-get install unzip dnsutils vim curl -y 
}

#####################
# Installing consul #
#####################
sudo mkdir -p /vagrant/pkg

which consul || {
    # check if consul file exist.
    CHECKFILE="/vagrant/pkg/consul_${CONSUL_VERSION}_linux_amd64.zip"
    if [ ! -f "$CHECKFILE" ]; then
        pushd /vagrant/pkg
        wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
        popd
    fi
    
    pushd /usr/bin/
    sudo unzip /vagrant/pkg/consul_${CONSUL_VERSION}_linux_amd64.zip 
    sudo chmod +x consul
    popd
}

killall consul
sudo mkdir -p /etc/consul.d/ /vagrant/consul_logs

# ###########################
# # Starting consul servers #
# ###########################
if [[ $IPs =~ 172.31.16 ]]; then # if 172.31.16 it is dc1
    DC_RANGE_OP="172.31.32"
    DC_RANGE="172.31.16"
    DC=dc1
elif [[ $IPs =~ 172.31.32 ]]; then  # if 172.31.32 it is dc2
    DC_RANGE_OP="172.31.16"
    DC_RANGE="172.31.32"
    DC=dc2
else 
    DC_RANGE_OP="172.31.32"
    DC_RANGE="172.31.48"
    DC=dc3
fi   
NODE_TYPE=client
  if [[ $HOST =~ ip-172-31-16-1 ]]; then
    # if the name contain server we are there
    NODE_TYPE=server
  fi
  LAN=", \"retry_join\": [ \"$DC_RANGE.11\", \"$DC_RANGE.12\", \"$DC_RANGE.13\" ]"
  WAN=", \"retry_join_wan\": [ \"$DC_RANGE_OP.11\", \"$DC_RANGE_OP.12\", \"$DC_RANGE_OP.13\" ]"
  

######################## 
# Creating consul user # 
########################
sudo consul -autocomplete-install
complete -C /usr/bin/consul consul
sudo groupadd --system consul
sudo useradd -s /sbin/nologin --system -g consul consul
sudo mkdir -p /opt/consul
sudo chown -R consul:consul /opt/consul
sudo chmod -R 775 /opt/consul

sudo cat <<EOF > /etc/consul.d/config.json
{ 
  "datacenter": "${DC}",
  "ui": true,
  "client_addr": "0.0.0.0",
  "bind_addr": "0.0.0.0",
  "advertise_addr": "${IPs}",
  "enable_script_checks": true,
  "data_dir": "/opt/consul"${LAN}
}
EOF

if [[ $IPs =~ 172.31.16.1 ]]; then
sudo cat <<EOF > /etc/consul.d/server.json
{ 
  "server": true,
  "bootstrap_expect": ${SERVER_COUNT}${WAN}
}
EOF
fi
sudo chown -R consul:consul /etc/consul.d/
sudo chmod -R 775 /etc/consul.d/
####################################
# Consul Server systemd Unit file  #
####################################
sudo cat <<EOF > /etc/systemd/system/consul.service
### BEGIN INIT INFO
# Provides:          consul
# Required-Start:    $local_fs $remote_fs
# Required-Stop:     $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Consul agent
# Description:       Consul service discovery framework
### END INIT INFO

[Unit]
Description=Consul server agent
Requires=network-online.target
After=network-online.target

[Service]
User=consul
Group=consul
PIDFile=/var/run/consul/consul.pid
PermissionsStartOnly=true
ExecStartPre=-/bin/mkdir -p /var/run/consul
ExecStartPre=/bin/chown -R consul:consul /var/run/consul
ExecStart=/usr/bin/consul agent \
    -config-dir=/etc/consul.d/ \
    -log-level=trace \
    -pid-file=/var/run/consul/consul.pid
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
KillSignal=SIGTERM
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target

EOF

###################
# Starting Consul #
###################
sudo systemctl daemon-reload
sudo systemctl start consul

###########################
# Redirecting conslul log #
###########################
    if [ -d /vagrant ]; then
        mkdir -p /vagrant/consul_logs
        journalctl -f -u consul.service &> /vagrant/consul_logs/${HOST}.log &
    else
        journalctl -f -u consul.service > /tmp/consul.log
    fi
echo consul started
set +x
sleep 20
consul members


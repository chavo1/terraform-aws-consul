#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

CONSUL_TEMPLATE_VERSION="0.20.0"

# install consul-template. 
which consul-template || {
    pushd /usr/local/bin/
        [ -f consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip ] || {
                sudo wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip   
        }
        sudo unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip
        sudo chmod +x consul
    popd
}


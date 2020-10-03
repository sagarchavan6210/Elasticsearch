#!/bin/bash

#Elasticsearch Installation

sudo apt update
sudo apt -y install default-jre curl jq unzip
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install elasticsearch
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

#Elasticsearch Configuration
cat <<EOT >> /etc/elasticsearch/elasticsearch.yml
network.host: 0.0.0.0
discovery.type: single-node
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true 
xpack.security.transport.ssl.verification_mode: certificate 
xpack.security.transport.ssl.keystore.path: elastic-certificates.p12
xpack.security.transport.ssl.truststore.path: elastic-certificates.p12
xpack.security.http.ssl.enabled: true
xpack.security.http.ssl.keystore.path: http.p12
EOT
sudo /bin/systemctl daemon-reload

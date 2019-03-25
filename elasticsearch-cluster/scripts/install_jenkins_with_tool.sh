#!/bin/bash

#title           : install_jenkins_with_tool.sh
#description     : This script will install java8 azure-cli.
#author		       : Pratik Anand
#date            : 2018-06-05
#version         : 0.1
#usage		       : bash install_jenkins_with_tool.sh
#notes           : This will install java version 8 azure-cli jq
#bash_version    : 4.4.19(1)-release 
#==============================================================================

script_version=0.1 ## Version change is compulsory 
terrform_version=0.11.11

apt-get install apt-transport-https
echo "Running apt update"
apt-get update --yes

#install openjdk8
add-apt-repository ppa:openjdk-r/ppa --yes
apt-get install openjdk-8-jre openjdk-8-jre-headless openjdk-8-jdk --yes

#install azure-cli
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
apt-get update --yes
apt-get install azure-cli --yes

# JQ install 
apt-get install jq --yes

## installing terraform
apt-get install unzip --yes 
wget https://releases.hashicorp.com/terraform/${terrform_version}/terraform_${terrform_version}_linux_amd64.zip > /dev/null
cd /tmp/
mkdir terraform
unzip terraform_${terrform_version}_linux_amd64.zip -d terraform
cp terraform/terraform  /usr/local/bin/

#installing Jenkins
echo "Installing new jenkins..."
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update -y
apt-get install jenkins -y

init 6

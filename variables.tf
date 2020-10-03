variable "aws_access_key"{
	default = "<Your Access Key>"
}
variable "aws_secret_key"{
	default = "<Your Secrete Key>"
}
variable "aws_region" {
	default = "ap-south-1"
}
variable "ami_id" {
	default = "ami-03f0fd1a2ba530e75"
}
variable "instance_type" {
	default = "t2.micro"
}
variable "key_pair" {
	default = "<key-name>"
}
variable "app_root_device_size" {
	default = "50"
}

variable "security_group_id" {
	default = "sg-03e7506da3e32efd7"	
}

variable "keyPath" {
	default = "/home/sagarc/CH-HOME/KeysForLogin/cb-demo/cb-demo.pem"
}

variable "os_name" {
	default = "test"
}

variable "availabilityZone" {
        default = "ap-south-1"
}

variable "vpc_cidr" {
	default = "10.0.0.0/16"
}

variable "dnsSupport" {
 default = true
}

variable "dnsHostNames" {
        default = true
}

variable "vpcCIDRblock" {
 default = "10.0.0.0/16"
}

variable "subnetCIDRblock" {
        default = "10.0.1.0/24"
}

variable "destinationCIDRblock" {
        default = "0.0.0.0/0"
}

variable "ingressCIDRblock" {
        type = "list"
        default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
        default = true
}

# end of variables.tf

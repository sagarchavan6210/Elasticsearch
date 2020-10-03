# AWS Provision for Terraform
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

# AWS VPC selection
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

# AWS Security Group creation
resource "aws_security_group" "es_sec_grp" {
  name        = "demo-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${data.aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "es-sg"
  }
}

#AWS instance creation
resource "aws_instance" "app" {
  ami                         = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_pair}"
  #vpc_security_group_ids      = ["${var.security_group_id}"]
  vpc_security_group_ids      = ["${aws_security_group.es_sec_grp.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "ubuntu18-es"
  }

provisioner "file" {
  source      = "./install_es.sh"
  destination = "/tmp/install_es.sh"
}

provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_es.sh",
      "sudo /tmp/install.sh_es",
    ]
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    password    = ""
    private_key = file(var.keyPath)
    host        = self.public_ip
  }

}

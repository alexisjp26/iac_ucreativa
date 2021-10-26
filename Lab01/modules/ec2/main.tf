terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
   cidr_block = "10.0.0.0/16"
   enable_dns_hostnames = true
   enable_dns_support = true

   tags = {
     "Name" = "VPC Gratis"
   }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
      "Name" = "Public Subnet Gratis"
    }  
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        "Name" = "Internet Gateway Gratis"
    } 
}

resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
    tags = {
        "Name" = "Route Table Gratis"
    } 
}

resource "aws_route_table_association" "route_table_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.route_table.id
}


resource "aws_security_group" "ec2_security_group" {
    name = "Security Group Gratis"
    description = "Security Group Gratis"

    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "EC2 Security Group Gratis"
    }

}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "iacalexis"       # Create a "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create a "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./myKey.pem"
  }
}

resource "aws_instance" "ec2" {
    ami = "ami-09e67e426f25ce0d7"
    instance_type = "t2.micro"

    subnet_id = aws_subnet.public_subnet.id
    vpc_security_group_ids = [ aws_security_group.ec2_security_group.id ]

    key_name = aws_key_pair.ec2_key_pair.key_name

    tags = {
      "Name" = "EC2 Gratis"
    }

} 
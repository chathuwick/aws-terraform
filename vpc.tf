resource "aws_vpc" "my-vpc" {
    cidr_block = "${var.cidr_vpc_block}"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags {
      name = "${var.tag_name}-VPC"
    }
  }

resource "aws_subnet" "Public-Subnet01" {
   vpc_id ="${aws_vpc.my-vpc.id}"
   cidr_block="${var.Cidr_Block_Public_Subnet01}"
   map_public_ip_on_launch = false
   availability_zone = "${var.Availability_Zone_01}"
   tags {
     name = "${var.tag_name}-Public-Subnet01"
   }
}

resource "aws_subnet" "Public-Subnet02" {
   vpc_id ="${aws_vpc.my-vpc.id}"
   cidr_block="${var.Cidr_Block_Public_Subnet02}"
   map_public_ip_on_launch = false
   availability_zone = "${var.Availability_Zone_02}"
   tags {
     name = "${var.tag_name}-Public-Subnet02"
   }
}

resource "aws_subnet" "Private-Subnet01" {
   vpc_id ="${aws_vpc.my-vpc.id}"
   cidr_block="${var.Cidr_Block_Private_Subnet01}"
   map_public_ip_on_launch = false
   availability_zone = "${var.Availability_Zone_01}"
   tags {
     name = "${var.tag_name}-Private-Subnet01"
   }
}

resource "aws_subnet" "Private-Subnet02" {
   vpc_id ="${aws_vpc.my-vpc.id}"
   cidr_block="${var.Cidr_Block_Private_Subnet02}"
   map_public_ip_on_launch = false
   availability_zone = "${var.Availability_Zone_02}"
   tags {
     name = "${var.tag_name}-Private-Subnet02"
   }
}

resource "aws_internet_gateway" "Internet-Gateway" {
  vpc_id = "${aws_vpc.my-vpc.id}"
  tags {
    name = "igw-${var.tag_name}"
  }
}

resource "aws_route_table" "PublicRTB" {
  vpc_id = "${aws_vpc.my-vpc.id}"
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.Internet-Gateway.id}"
  }
  tags {
    name = "${var.tag_name}-public-RTB"
  }
}

resource "aws_security_group" "ELB-SG" {
    name = "${var.tag_name}-ELB-SG"
    vpc_id = "${aws_vpc.my-vpc.id}"
    ingress{
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "${var.tag_name}-ELB-SG"
    }
}

resource "aws_security_group" "App-SG" {
    name = "${var.tag_name}-ELB-SG"
    vpc_id = "${aws_vpc.my-vpc.id}"
    ingress{
      from_port = 80
      to_port = 80
      protocol = "tcp"
      security_groups = "${aws_security_group.ELB-SG.id}"
    }
    egress{
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "${var.tag_name}-App-SG"
    }
}

resource "aws_security_group" "DB-SG" {
    name = "${var.tag_name}-ELB-SG"
    vpc_id = "${aws_vpc.my-vpc.id}"
    ingress{
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      security_groups = "${aws_security_group.App-SG.id}"
    }
    egress{
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "${var.tag_name}-DB-SG"
    }
}

resource "aws_security_group" "NAT-SG" {
    name = "${var.tag_name}-NAT-SG"
    vpc_id = "${aws_vpc.my-vpc.id}"
    ingress{
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }    
    egress{
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "${var.tag_name}-NAT-SG"
    }
}

resource "aws_route_table" "PrivateRTB" {
  vpc_id = "${aws_vpc.my-vpc.id}"
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.Internet-Gateway.id}"
  }
  tags {
    name = "k8-public-route-${var.tag_name}"
  }
}


variable "cidr_vpc_block" {
  default = "10.0.0.0/16"
}

variable "tag_name" {
  default = "MyVPCV"
}

variable "Availability_Zone_01" {
  default = "us-east-1a"
}

variable "Availability_Zone_02" {
  default = "us-east-1b"
}

variable "Cidr_Block_Public_Subnet01" {
  default = "10.0.1.0/24"
}

variable "Cidr_Block_Public_Subnet02" {
  default = "10.0.2.0/24"
}

variable "Cidr_Block_Private_Subnet01" {
  default = "10.0.3.0/24"
}

variable "Cidr_Block_Private_Subnet02" {
  default = "10.0.4.0/24"
}

variable "nat_ami" {
  default = "ami-01623d7b"
}

variable "key_name" {
  default="Chathu-Key"
}
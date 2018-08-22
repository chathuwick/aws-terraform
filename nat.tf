resource "aws_instance" "nat" {
 ami                         = "${var.nat_ami}"
 instance_type               = "m3.medium"
 key_name                    = "${var.key_name}"
 vpc_security_group_ids      = ["${aws_security_group.NAT-SG.id}"]
 subnet_id                   = "${aws_subnet.Public-Subnet01.id}"
 associate_public_ip_address = true
 source_dest_check           = false

 root_block_device {
   volume_type           = "gp2"
   volume_size           = "8"
   delete_on_termination = true
 }

 tags {
     Name = "${var.tag_name}-NAT"
    }
}

/* Elastic IPs*/
resource "aws_eip" "nat" {
 instance = "${aws_instance.nat.id}"
 vpc      = true
}
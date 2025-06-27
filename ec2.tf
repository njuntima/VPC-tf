#keys
resource "aws_key_pair" "keys"{
    count = 4
    public_key = tls_private_key.rsa[count.index].public_key_openssh
    key_name = "key-${count.index}"
}

resource "tls_private_key" "rsa"{
    count = 4
    algorithm = "RSA"
    rsa_bits = 4096
    
}

resource "local_file" "tf-keys"{
    count = 4
    content = tls_private_key.rsa[count.index].private_key_pem
    filename = "key-${count.index}.pem"
    file_permission = "0400"
}

# instance
resource "aws_instance" "intances"{
    count = 4
    ami = "ami-020cba7c55df1f615"
    instance_type = "t2.micro"
    key_name = aws_key_pair.keys[count.index].key_name

    subnet_id = local.subnets[count.index]
    security_groups = [ local.sgs[count.index] ]

    associate_public_ip_address = local.public_ips[count.index]

    tags = {
        Name = "instance-${count.index}"
    }
}



# security groups
resource "aws_security_group" "sg_tf_vpc_public" {

vpc_id = aws_vpc.new_vpc.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # all protocol
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # ssh
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp" # all protocol
    cidr_blocks      = concat([local.workstation_ip],local.cidrs)
    
  }

  # icmp (ping)
  ingress {
    from_port        = -1
    to_port          = -1
    protocol         = "icmp" # all protocol
    cidr_blocks      = concat([local.workstation_ip],local.cidrs)
  }

  tags = {
    Name = "sg-public-tf"
  }

}

resource "aws_security_group" "sg_tf_vpc_private" {

vpc_id = aws_vpc.new_vpc.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # all protocol
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # ssh
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp" # all protocol
    cidr_blocks      = local.cidrs
  }

  # icmp (ping)
  ingress {
    from_port        = -1
    to_port          = -1
    protocol         = "icmp" # all protocol
    cidr_blocks      = local.cidrs
  }

  tags = {
    Name = "sg-private-tf"
  }

}

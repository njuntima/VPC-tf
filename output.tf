# debug purposes

output "private_subnet"{
    value = aws_subnet.private_subnets
}

output "public_subnet"{
    value = aws_subnet.public_subnets
}


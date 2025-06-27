locals {
    workstation_ip = "${chomp(data.http.myip.response_body)}/32"
    # request_body - POST
    # response_body - GET
    
    
    cidrs = concat(var.public_cidrs,
                    var.private_cidrs)


    # first 2 public, last 2 private
    sgs = [aws_security_group.sg_tf_vpc_public.id,
    aws_security_group.sg_tf_vpc_public.id,
    aws_security_group.sg_tf_vpc_private.id,
    aws_security_group.sg_tf_vpc_private.id
    ]

    subnets = concat(aws_subnet.public_subnets[*].id,
                    aws_subnet.private_subnets[*].id)

    public_ips = [true,true,false,false]
}
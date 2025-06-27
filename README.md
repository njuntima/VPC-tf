# original is the original doc all in one

# main.tf
Creates a VPC in AWS with:
1 private and 1 public subnet
1 private and 1 public route table
s3 endpoint


# ec2.tf
launch 1 ec2 instance in each subnet
creates public/private sg

# to connect from instnace in public subnet to private
1. In local machine run: 
    1. ```eval "$(ssh-agent -s)"```
    2. ```ssh-add key-to-private-ec2.pem```
    3. ``` ssh -A -i  key-to-public-ec2.pem user@public-ec2-ip```
2. when connected to the public ec2, run:
    1. ```ssh -i /dev/null user@private-ec2-ip```


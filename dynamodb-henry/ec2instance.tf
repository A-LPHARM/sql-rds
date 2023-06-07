# Create the EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = "ami-0889a44b331db0194" # Replace with your desired AMI ID
  instance_type = "t2.micro"
  key_name      = "******"
  subnet_id     = aws_subnet.publicsubnet.id
  vpc_security_group_ids      = [aws_security_group.webserver-secgrp.id]

   tags = {
    Name = "henry"
  }
}




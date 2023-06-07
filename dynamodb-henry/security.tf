
# Create Security Group
resource "aws_security_group" "secgrp" {
  name_prefix = "default-"
  vpc_id      = aws_vpc.henryvpc.id

# To Allow SSH Transport
  ingress {
    from_port     = 22
    to_port       = 22
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

# To Allow HTTP Transport
  ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################################################################
# Create security group for the bastion host 
# terraform aws create security group
  resource "aws_security_group" "ssh-secgrp" {
  name_prefix = "ssh access"
  description =  "Enable SSH on port 22"
  vpc_id      = aws_vpc.henryvpc.id

# To Create bastion security group with access ip
  ingress {
    from_port      = 22
    to_port        = 22
    protocol       = "tcp"
    cidr_blocks    = ["0.0.0.0/0"] # insert your local ip address in bastion host
  }

  egress {
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
    cidr_blocks    = ["0.0.0.0/0"]
  }
} 

####################################################################

resource "aws_security_group" "webserver-secgrp" {
  name_prefix = "webserver-security-group"
  description =  "Enable http and SSH on port 80 and port 22 via ssh grp"
  vpc_id      = aws_vpc.henryvpc.id

#  To Allow HTTP Transport into the ssh-grp
  ingress {
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]  # security for ec2 instance without bastion host
  }

#  To Allow SSH Transport into the ssh-grp
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###########################################################################
###########################################################################

#  Create the security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "Database security group"
  description =  "enable MYSQL/AURORA access on port 3306"
  vpc_id      = aws_vpc.henryvpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = ["${aws_security_group.webserver-secgrp.id}"] # Allow inbound traffic from bastion subnet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

######################################################################################################
######################################################################################################



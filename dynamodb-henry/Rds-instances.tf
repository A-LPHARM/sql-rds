# Create the MySQL RDS database instance
resource "aws_db_instance" "mysql_instance" {
  engine                  = "mysql"
  engine_version          = "8.0.32"
  instance_class          = "db.t2.micro"
  allocated_storage       = 200
  storage_type            = "gp3"
  availability_zone       = "us-east-1a"
  db_name                 = var.db_name
  username                = var.db_username
  password                = "Admin123b"
  port                    = 3306
  multi_az                = false
  publicly_accessible     = true
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.subnetdb.id
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  tags = {
    Name = "myrds"
  }
}

resource "aws_db_subnet_group" "subnetdb" {
  name       = "henrysubnetdb"
  subnet_ids = [aws_subnet.privatesubnet3.id , aws_subnet.privatesubnet4.id]

   tags = {
     Name = "testDbsubnet"
  }
}
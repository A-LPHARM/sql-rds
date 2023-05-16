# Create the MySQL RDS database instance
resource "aws_db_instance" "mysql_instance" {
  engine            = "mysql"
  engine_version    = "8.0.32"
  instance_class    = "db.t2.micro"
  allocated_storage = 200
  storage_type      = "gp3"
  name              = var.db_name
  username          = var.db_username
  password          = var.db_password
  port              = 3306
  backup_retention_period = 7
  multi_az          = false
  publicly_accessible    = true
  skip_final_snapshot  = true
}

  vars = {
    db_host     = aws_db_instance.mysql_instance.address
    db_port     = aws_db_instance.mysql_instance.port
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
}


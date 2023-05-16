# Create the EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = "ami-xxxxxxxx" # Replace with your desired AMI ID
  instance_type = "t2.micro"
  key_name      = "my-keypair"
  subnet_id     = aws_subnet.public.id
}

 provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y freetds-common freetds-bin unixodbc",
      "echo '[mydb]' | sudo tee -a /etc/freetds/freetds.conf",
      "echo '    host = ${aws_db_instance.sql_db.address}' | sudo tee -a /etc/freetds/freetds.conf",
      "echo '    port = ${aws_db_instance.sql_db.port}' | sudo tee -a /etc/freetds/freetds.conf",
      "echo '    tds version = 8.0' | sudo tee -a /etc/freetds/freetds.conf",
      "tsql -S mydb -U ${var.db_username} -P ${var.db_password} -Q 'SELECT @@VERSION;'"
    ]
}

# Below is the resource block which creates EC2 Instance
# resource "aws_instance" "test" {
#   count = length(var.ec2_name_tag)
#   key_name = "my-keypair"
#   subnet_id = aws_subnet.public.id

#   ami           = var.ami_ids[count.index]
#   instance_type = var.instance_type[count.index]
#   tags = {
#     Name = var.ec2_name_tag[count.index]
#   }
# }
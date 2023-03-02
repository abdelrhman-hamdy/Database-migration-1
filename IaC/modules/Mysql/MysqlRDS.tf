terraform {
  required_version = ">= 0.14.9"
}



resource "aws_security_group" "mysql_security_group" {
  name="mysql_security_group"
  description = "Enable connections to mysql server "
  ingress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
  } 
  egress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  } 
}

resource "aws_db_instance" "mysql-database" {
allocated_storage = 20
identifier = "mysql-database"
storage_type = "gp2"
engine = "mysql"
engine_version = "8.0.27"
instance_class = "db.t2.micro"
name = "server"
username = var.db_username
password = var.db_password
publicly_accessible    = true
skip_final_snapshot    = true
multi_az = false
auto_minor_version_upgrade = false
vpc_security_group_ids = [aws_security_group.mysql_security_group.id]
  tags = {
    Name = "mysql-database"
  }
depends_on = [ aws_security_group.mysql_security_group ]
}

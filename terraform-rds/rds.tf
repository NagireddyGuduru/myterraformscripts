# Create subnet group with private subnets

resource "aws_db_subnet_group" "rds_subnets" {
  name       = "myapp_rds_group"
  subnet_ids = ["${aws_subnet.rds_subnets.*.id}"]

  tags {
    Name = "My DB subnet group"
  }
}

# RDS with mysql engine

resource "aws_db_instance" "myapp_rds" {
  identifier           = "myapp-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "javahome"
  username             = "javahome"
  password             = "javahome"
  db_subnet_group_name = "${aws_db_subnet_group.rds_subnets.id}"
}

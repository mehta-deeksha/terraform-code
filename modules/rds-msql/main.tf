resource "aws_db_instance" "rds_instance" {
  allocated_storage      = var.allocated_storage
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.instance_class
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false

  tags = {
    Name = "RDS-Instance"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "RDS-SG"
  description = "Allow inbound access from EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [var.ec2_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "RDS Subnet Group"
  }
}


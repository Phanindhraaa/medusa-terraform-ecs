resource "aws_db_instance" "medusa_rds" {
  allocated_storage      = var.db_allocated_storage
  engine                 = "postgres"
  engine_version         = "15.13" # or "17.3"
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  db_subnet_group_name = aws_db_subnet_group.medusa_subnet_group.name

  tags = {
    Name = "medusa-rds-instance"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "medusa-db-sg"
  description = "Security group for Medusa RDS instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Consider restricting this for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "medusa-db-sg"
  }
}

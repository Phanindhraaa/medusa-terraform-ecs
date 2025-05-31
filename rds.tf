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

  tags = {
    Name = "medusa-rds-instance"
  }
}

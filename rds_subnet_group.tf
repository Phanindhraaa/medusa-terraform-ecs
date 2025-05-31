resource "aws_db_subnet_group" "medusa_subnet_group" {
  name = "medusa-db-subnet-group"
  subnet_ids = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id
  ]

  tags = {
    Name = "medusa-db-subnet-group"
  }
}

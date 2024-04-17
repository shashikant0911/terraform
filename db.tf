resource "aws_db_instance" "my_postgresql_db" {
  db_name                   = "IRSTest2"
  allocated_storage         = var.allocated_storage
  storage_type              = var.storage_type
  engine                    = var.engine
  backup_retention_period   = 7
  engine_version            = var.engine_version
  instance_class            = var.instance_class
  username                  = "irs"
  password                  = "admin123"
  parameter_group_name      = var.parameter_group_name
  final_snapshot_identifier = var.final_snapshot_identifier
  db_subnet_group_name      = aws_db_subnet_group.my_db_subnet_group.name
  skip_final_snapshot       = true
  vpc_security_group_ids    = [aws_security_group.irs-db.id]

  tags = {
    Name = "MyPostgresDB"
  }
}

resource "aws_security_group" "my_db_sg" {
  name        = "my-postgresql-db-sg"
  description = "Security group for PostgreSQL RDS instance"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = aws_subnet.private_subnet[*].id
}
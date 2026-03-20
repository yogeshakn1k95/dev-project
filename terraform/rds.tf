resource "aws_db_subnet_group" "db_subnet" {
  name       = "devops-db-subnet"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_security_group" "rds_sg" {
  name = "devops-rds-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_db_instance" "mysql" {
  identifier           = "devops-db"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20

  db_name  = "devopsdb"
  username = "admin"
  password = "password123"

  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
}

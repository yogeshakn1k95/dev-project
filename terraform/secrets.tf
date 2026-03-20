#resource "aws_secretsmanager_secret" "app_secret" {
#  name = "devops-app-secret"

#  tags = {
#    Environment = "dev"
#  }
#}

#resource "aws_secretsmanager_secret_version" "secret_value" {
#  secret_id = aws_secretsmanager_secret.app_secret.id

#  secret_string = jsonencode({
#    username = "admin"
#    password = "mypassword"
#  })
#}

# -----------------------------
# Secrets Manager
# -----------------------------
#resource "aws_secretsmanager_secret" "db_secret" {
#  name = "devops-db-secret"
#}

#resource "aws_secretsmanager_secret_version" "db_secret_value" {
#  secret_id = aws_secretsmanager_secret.db_secret.id

#  secret_string = jsonencode({
#    DB_USER = "admin"
#    DB_PASS = "password123"
#    DB_HOST = aws_db_instance.mysql.address
#    DB_NAME = "devopsdb"
#  })
#}

resource "aws_secretsmanager_secret" "app_secret" {
  name = "devops-app-secret"
}

resource "aws_secretsmanager_secret_version" "secret_value" {
  secret_id = aws_secretsmanager_secret.app_secret.id

  secret_string = jsonencode({
    DB_USER = "admin"
    DB_PASS = "password123"
    DB_HOST = aws_db_instance.mysql.address
  })
}

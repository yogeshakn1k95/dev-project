resource "aws_secretsmanager_secret" "app_secret" {
  name = "devops-app-secret"
}

resource "aws_secretsmanager_secret_version" "secret_value" {
  secret_id = aws_secretsmanager_secret.app_secret.id

  secret_string = jsonencode({
    DB_USER = "admin"
    DB_PASS = random_password.db_pass.result
    DB_HOST = aws_db_instance.mysql.address
  })
}

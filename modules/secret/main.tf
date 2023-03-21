resource "aws_secretsmanager_secret" "secret" {
  name = "dragondrop_${var.name}"
}

resource "aws_secretsmanager_secret_version" "default_version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = ""
}

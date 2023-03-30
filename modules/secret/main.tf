resource "aws_secretsmanager_secret" "secret" {
  name = "dragondrop_${var.name}"
  tags = merge(
    { origin = "dragondrop-compute-module" },
    var.tags,
  )
}

resource "aws_secretsmanager_secret_version" "default_version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = var.default_secret_value
}

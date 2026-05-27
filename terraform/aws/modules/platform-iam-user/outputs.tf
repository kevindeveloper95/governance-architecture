output "user_name" {
  value = aws_iam_user.this.name
}

output "user_arn" {
  value = aws_iam_user.this.arn
}

output "initial_password" {
  description = "Contraseña generada (solo al crear; ver terraform output -raw)"
  value       = try(aws_iam_user_login_profile.this[0].password, null)
  sensitive   = true
}

resource "aws_iam_user" "this" {
  name          = var.user_name
  force_destroy = var.force_destroy

  tags = var.tags
}

resource "aws_iam_user_policy_attachment" "administrator" {
  count = var.attach_administrator_access ? 1 : 0

  user       = aws_iam_user.this.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Provider AWS 5.x: no se puede fijar password a mano; Terraform genera una temporal.
resource "aws_iam_user_login_profile" "this" {
  count = var.create_console_login ? 1 : 0

  user                    = aws_iam_user.this.name
  password_length         = var.password_length
  password_reset_required = var.password_reset_required
}

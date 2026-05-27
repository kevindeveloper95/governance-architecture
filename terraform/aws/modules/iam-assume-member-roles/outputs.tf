output "policy_arn" {
  value = aws_iam_policy.assume_member_roles.arn
}

output "member_role_arns" {
  value = var.member_role_arns
}

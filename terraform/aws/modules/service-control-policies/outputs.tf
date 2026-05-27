output "policy_ids" {
  value = { for k, p in aws_organizations_policy.scp : k => p.id }
}

output "policy_arns" {
  value = { for k, p in aws_organizations_policy.scp : k => p.arn }
}

output "account_ids" {
  value = {
    for key, acc in aws_organizations_account.member : key => acc.id
  }
}

output "account_arns" {
  value = {
    for key, acc in aws_organizations_account.member : key => acc.arn
  }
}

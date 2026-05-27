resource "aws_organizations_account" "member" {
  for_each = var.accounts

  name                       = each.value.name
  email                      = each.value.email
  parent_id                  = var.ou_ids[each.value.ou]
  role_name                  = each.value.role_name
  iam_user_access_to_billing = "DENY"

  # La creación desde Organizations suele tardar varios minutos
  timeouts {
    create = "30m"
  }
}

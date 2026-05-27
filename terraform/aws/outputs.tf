output "organization_id" {
  value = aws_organizations_organization.current.id
}

output "management_account_id" {
  value = aws_organizations_organization.current.master_account_id
}

output "organizational_unit_ids" {
  value = module.organizational_units.ou_ids
}

output "member_account_ids" {
  value = module.member_accounts.account_ids
}

output "switch_role_console" {
  description = "Datos para Switch role (Account ID + OrganizationAccountAccessRole)"
  value       = local.switch_role_console
}

output "platform_management_user_arn" {
  value = var.create_platform_management_user ? module.platform_user_kevin_management[0].user_arn : null
}

output "platform_management_user_initial_password" {
  description = "Contraseña generada: terraform output -raw platform_management_user_initial_password"
  value       = var.create_platform_management_user ? module.platform_user_kevin_management[0].initial_password : null
  sensitive   = true
}

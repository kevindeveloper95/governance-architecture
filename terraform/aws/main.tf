# =============================================================================
# Organización (importar la primera vez: terraform import aws_organizations_organization.current o-XXXX)
# =============================================================================

resource "aws_organizations_organization" "current" {
  aws_service_access_principals = var.organization_service_principals

  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
  feature_set          = "ALL"
}

# =============================================================================
# Locals (ARNs para Switch role y outputs)
# =============================================================================

locals {
  service_control_policies = merge(
    {
      deny-leave-organization = {
        description = "Impide que cuentas abandonen la organización"
        policy      = file("${path.module}/policies/scp/deny-leave-organization.json")
        targets     = ["Development", "Production"]
      }
    },
    var.service_control_policies
  )

  member_account_ids = module.member_accounts.account_ids

  member_role_arns = [
    for key, acc in var.member_accounts :
    "arn:aws:iam::${local.member_account_ids[key]}:role/${coalesce(acc.role_name, "OrganizationAccountAccessRole")}"
  ]

  switch_role_console = {
    for key, acc in var.member_accounts : key => {
      account_id   = local.member_account_ids[key]
      role_name    = coalesce(acc.role_name, "OrganizationAccountAccessRole")
      display_name = acc.name
      ou           = acc.ou
    }
  }
}

# =============================================================================
# OUs y cuentas dev / prod
# =============================================================================

module "organizational_units" {
  source = "./modules/organizational-units"

  root_id              = aws_organizations_organization.current.roots[0].id
  organizational_units = var.organizational_units
}

module "member_accounts" {
  source = "./modules/member-accounts"

  accounts = var.member_accounts
  ou_ids   = module.organizational_units.ou_ids

  depends_on = [module.organizational_units]
}

# =============================================================================
# SCPs
# =============================================================================

module "service_control_policies" {
  source = "./modules/service-control-policies"

  name_prefix = var.project_name
  policies    = local.service_control_policies
  target_ids = merge(
    { root = aws_organizations_organization.current.roots[0].id },
    module.organizational_units.ou_ids
  )

  depends_on = [
    aws_organizations_organization.current,
    module.organizational_units,
  ]
}

# =============================================================================
# IAM — usuario management + Switch role a cuentas hijas
# =============================================================================

module "platform_user_kevin_management" {
  count  = var.create_platform_management_user ? 1 : 0
  source = "./modules/platform-iam-user"

  user_name            = var.platform_management_user_name
  create_console_login = true
  attach_administrator_access = true
  password_reset_required     = true

  tags = merge(var.default_tags, { Purpose = "platform-management" })
}

module "iam_assume_member_roles" {
  count  = var.enable_assume_member_roles && length(local.member_role_arns) > 0 ? 1 : 0
  source = "./modules/iam-assume-member-roles"

  name_prefix      = var.project_name
  iam_user_names   = var.iam_users_with_switch_role
  member_role_arns = local.member_role_arns
  tags             = var.default_tags

  depends_on = [module.member_accounts, module.platform_user_kevin_management]
}

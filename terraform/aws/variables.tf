variable "aws_region" {
  description = "Región del provider (cuenta management)"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Prefijo en nombres de recursos"
  type        = string
  default     = "governance"
}

variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "organizational_units" {
  description = "OUs bajo el root (parent = root o nombre de otra OU)"
  type = map(object({
    parent = string
  }))
  default = {
    Development = { parent = "root" }
    Production  = { parent = "root" }
  }
}

variable "member_accounts" {
  description = "Cuentas creadas en la org (email único por cuenta AWS)"
  type = map(object({
    ou        = string
    email     = string
    name      = string
    role_name = optional(string, "OrganizationAccountAccessRole")
  }))
  default = {
    development = {
      ou    = "Development"
      email = "kemen95+dev2@hotmail.com"
      name  = "development"
    }
    production = {
      ou    = "Production"
      email = "kemen95+production@hotmail.com"
      name  = "production"
    }
  }
}

variable "service_control_policies" {
  description = "SCPs extra (el default deny-leave está en main.tf locals)"
  type = map(object({
    description = string
    policy      = string
    targets     = list(string)
  }))
  default = {}
}

variable "organization_service_principals" {
  type = list(string)
  default = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]
}

variable "create_platform_management_user" {
  type    = bool
  default = true
}

variable "platform_management_user_name" {
  type    = string
  default = "kevinManagmentAccount"
}

variable "enable_assume_member_roles" {
  description = "Permite Switch role a dev/prod para usuarios listados"
  type        = bool
  default     = true
}

variable "iam_users_with_switch_role" {
  type    = list(string)
  default = ["kevinManagmentAccount"]
}

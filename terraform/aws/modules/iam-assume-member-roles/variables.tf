variable "name_prefix" {
  type = string
}

variable "iam_user_names" {
  description = "Usuarios IAM en management que podrán usar Switch role"
  type        = list(string)
}

variable "member_role_arns" {
  description = "ARNs de roles en cuentas hijas (ej. OrganizationAccountAccessRole)"
  type        = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

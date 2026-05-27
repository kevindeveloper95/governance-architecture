variable "accounts" {
  description = "Cuentas a crear (vacío = no crear ninguna)"
  type = map(object({
    ou        = string
    email     = string
    name      = string
    role_name = optional(string, "OrganizationAccountAccessRole")
  }))
  default = {}
}

variable "ou_ids" {
  description = "Mapa nombre OU -> ID (del módulo organizational-units)"
  type        = map(string)
}

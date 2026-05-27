variable "root_id" {
  description = "ID del root de la organización"
  type        = string
}

variable "organizational_units" {
  description = "Mapa de OUs: nombre -> { parent = root | nombre OU padre }"
  type = map(object({
    parent = string
  }))
}

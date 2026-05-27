variable "name_prefix" {
  description = "Prefijo en el nombre de las SCPs"
  type        = string
  default     = "governance"
}

variable "policies" {
  description = "SCPs: policy JSON string y targets (nombres de OU o root)"
  type = map(object({
    description = string
    policy      = string
    targets     = list(string)
  }))
}

variable "target_ids" {
  description = "Mapa nombre (OU o root) -> ID para adjuntar políticas"
  type        = map(string)
}

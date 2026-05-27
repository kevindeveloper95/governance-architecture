variable "user_name" {
  type = string
}

variable "create_console_login" {
  type    = bool
  default = true
}

variable "password_length" {
  description = "Longitud de la contraseña generada por Terraform (consola IAM)"
  type        = number
  default     = 16
}

variable "attach_administrator_access" {
  type    = bool
  default = true
}

variable "password_reset_required" {
  type    = bool
  default = true
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}

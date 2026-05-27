# backend.tf — Dónde se guarda el "estado" (terraform.tfstate)
#
# Por defecto el estado es un archivo LOCAL en tu PC (.terraform/ y terraform.tfstate).
# En equipo/producción conviene backend remoto (S3, Azure Storage, Terraform Cloud...).
#
# Descomenta y adapta cuando lo necesites:

# terraform {
#   backend "s3" {
#     bucket         = "mi-empresa-terraform-state"
#     key            = "governance/terraform.tfstate"
#     region         = "eu-west-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }

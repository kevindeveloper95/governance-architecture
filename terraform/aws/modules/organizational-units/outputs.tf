output "ou_ids" {
  description = "Nombre de OU -> ID"
  value = {
    for name, ou in local.all_ous : name => ou.id
  }
}

output "ou_arns" {
  value = {
    for name, ou in local.all_ous : name => ou.arn
  }
}

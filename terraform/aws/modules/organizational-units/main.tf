locals {
  root_children = {
    for name, cfg in var.organizational_units : name => cfg
    if cfg.parent == "root"
  }

  nested = {
    for name, cfg in var.organizational_units : name => cfg
    if cfg.parent != "root"
  }
}

resource "aws_organizations_organizational_unit" "root_level" {
  for_each = local.root_children

  name      = each.key
  parent_id = var.root_id
}

resource "aws_organizations_organizational_unit" "nested" {
  for_each = local.nested

  name      = each.key
  parent_id = aws_organizations_organizational_unit.root_level[each.value.parent].id
}

locals {
  all_ous = merge(
    aws_organizations_organizational_unit.root_level,
    aws_organizations_organizational_unit.nested
  )
}

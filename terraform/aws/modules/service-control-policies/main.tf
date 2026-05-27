resource "aws_organizations_policy" "scp" {
  for_each = var.policies

  name        = "${var.name_prefix}-${each.key}"
  description = each.value.description
  type        = "SERVICE_CONTROL_POLICY"
  content     = each.value.policy
}

resource "aws_organizations_policy_attachment" "scp" {
  for_each = {
    for pair in flatten([
      for policy_key, policy in var.policies : [
        for target in policy.targets : {
          key        = "${policy_key}-${target}"
          policy_key = policy_key
          target     = target
        }
      ]
    ]) : pair.key => pair
  }

  policy_id = aws_organizations_policy.scp[each.value.policy_key].id
  target_id = var.target_ids[each.value.target]
}

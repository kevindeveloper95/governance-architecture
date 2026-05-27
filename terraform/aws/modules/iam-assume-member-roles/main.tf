data "aws_iam_policy_document" "assume_member_roles" {
  statement {
    sid    = "AssumeOrganizationAccountAccessRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]
    resources = var.member_role_arns
  }
}

resource "aws_iam_policy" "assume_member_roles" {
  name        = "${var.name_prefix}-assume-member-accounts"
  description = "Permite Switch role / sts:AssumeRole a cuentas miembro de la org"
  policy      = data.aws_iam_policy_document.assume_member_roles.json

  tags = var.tags
}

resource "aws_iam_user_policy_attachment" "this" {
  for_each = toset(var.iam_user_names)

  user       = each.value
  policy_arn = aws_iam_policy.assume_member_roles.arn
}

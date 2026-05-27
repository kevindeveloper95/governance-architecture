# Governance AWS (Terraform)

Stack mínimo en la **cuenta management**:

| Recurso | Módulo |
|---------|--------|
| Habilitar SCPs | `organization.tf` |
| OUs Development / Production | `organizational-units` |
| Cuentas dev y prod (creadas en su OU) | `member-accounts` |
| SCP: no salir de la org | `service-control-policies` |
| Usuario `kevinManagmentAccount` + admin | `platform-iam-user` |
| Switch role a dev/prod | `iam-assume-member-roles` |

## Requisitos

- Terraform >= 1.5, AWS CLI configurado en **management**
- Primera vez con org existente:

```powershell
terraform import aws_organizations_organization.current o-TU_ORG_ID
```

## Uso

```powershell
cd terraform/aws
copy terraform.tfvars.example terraform.tfvars

terraform init
terraform plan
terraform apply
```

La creación de cada cuenta puede tardar **varios minutos**.

Contraseña de `kevinManagmentAccount` (generada en el apply):

```powershell
terraform output -raw platform_management_user_initial_password
```

## Switch role (manual en consola)

1. Login como `kevinManagmentAccount`
2. `terraform output switch_role_console`
3. Switch role → Account ID + `OrganizationAccountAccessRole`

O: Organizations → cuenta → **Access account**.

## Estructura

```
terraform/aws/
├── main.tf              ← org, módulos, IAM (todo el despliegue)
├── variables.tf
├── outputs.tf
├── providers.tf
├── versions.tf
├── backend.tf           ← state remoto (opcional, comentado)
├── policies/scp/
└── modules/
    ├── organizational-units/
    ├── member-accounts/
    ├── service-control-policies/
    ├── platform-iam-user/
    └── iam-assume-member-roles/
```

## Costos

`terraform destroy` elimina lo gestionado; **cerrar cuentas miembro** en Organizations si quieres dejar de pagar por ellas.

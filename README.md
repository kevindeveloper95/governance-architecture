# 🏛️ Governance — AWS Organizations con Terraform

[![Terraform](https://img.shields.io/badge/Terraform-≥1.5-844FBA?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Organizations-232F3E?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/organizations/)
[![License](https://img.shields.io/badge/License-Educational-blue)](#)

Proyecto de aprendizaje para implementar **gobernanza básica en AWS** desde la **cuenta management**: una sola organización, unidades organizativas (OUs), cuentas miembro, políticas de control de servicio (SCPs) e identidad IAM con **Switch role** hacia Development y Production.

> ☁️ **Alcance:** Organizations + OUs + cuentas + SCP + IAM. Sin AWS Control Tower ni cuentas Audit/Log Archive en este stack.

---

## 📐 Arquitectura

![Diagrama de gobernanza AWS](Diagram/Diagrama%20Governance.png)

*Fuente editable:* [`Diagram/Diagrama Governance.drawio`](Diagram/Diagrama%20Governance.drawio)

### 🔍 Qué muestra el diagrama

| Elemento | Descripción |
|----------|-------------|
| 🟣 **Management Account** | Cuenta raíz de la organización. Desde aquí se administra la org y el usuario **Kevin** (`kevinManagmentAccount`) opera en consola. |
| 📦 **Development OU / Production OU** | Dos OUs bajo el root que agrupan entornos. Cada una contiene su cuenta miembro (development / production). |
| 🔴 **Cuentas miembro** | Cuentas AWS hijas creadas y asociadas a su OU mediante Terraform. |
| 🛡️ **SCP** | Política *Prevent AWS Accounts from leaving the organization* aplicada a las OUs (y recursos bajo ellas), para impedir `organizations:LeaveOrganization`. |
| 🔄 **Role Switch** | Flechas naranjas: el usuario en management asume `OrganizationAccountAccessRole` en cada cuenta hija para administrarlas sin credenciales separadas por cuenta. |
| 👤 **Create IAM Role** | Al crear o unir una cuenta a Organizations, AWS provisiona el rol de acceso cross-account que habilita el Switch role. |

En la implementación actual, las cuentas se **crean** con el módulo `member-accounts` (no por invitación manual). El flujo de acceso y las SCPs coinciden con el diagrama.

---

## ✨ Qué incluye este repositorio

| Área | Contenido |
|------|-----------|
| 🏗️ **Infraestructura** | Código Terraform en [`terraform/aws/`](terraform/aws/) |
| 📂 **OUs** | `Development` y `Production` bajo el root |
| 🧾 **Cuentas** | development y production (emails configurables en `terraform.tfvars`) |
| 🔒 **SCP** | Denegar abandono de la organización |
| 👤 **IAM** | Usuario management con admin + política para asumir roles en cuentas hijas |
| 📤 **Outputs** | IDs de cuentas, datos de Switch role y contraseña inicial del usuario IAM |

---

## 📁 Estructura del proyecto

```
Governance/
├── Diagram/
│   ├── Diagrama Governance.drawio    # Diagrama editable (draw.io)
│   └── Diagrama Governance.png       # Imagen para documentación
├── README.md                         # Este archivo
└── terraform/aws/
    ├── main.tf                       # Org, OUs, cuentas, SCPs, IAM
    ├── variables.tf / outputs.tf
    ├── policies/scp/                 # JSON de SCPs
    └── modules/                      # organizational-units, member-accounts, ...
```

---

## 🚀 Inicio rápido

### 📋 Requisitos

- Terraform **≥ 1.5**
- AWS CLI / credenciales de la **cuenta management**
- Permisos para Organizations, crear cuentas e IAM

### ⚙️ Despliegue

```powershell
cd terraform/aws
copy terraform.tfvars.example terraform.tfvars
# Edita terraform.tfvars (emails, región, etc.)

terraform init
terraform plan
terraform apply
```

⏱️ La creación de cada cuenta miembro puede tardar **varios minutos**.

### 🔑 Primera vez con organización ya existente

```powershell
terraform import aws_organizations_organization.current o-TU_ORG_ID
```

### 🔐 Contraseña del usuario management

Tras el `apply`, la contraseña se genera automáticamente:

```powershell
terraform output -raw platform_management_user_initial_password
```

### 🔄 Switch role en consola

Usa el output `switch_role_console` (Account ID + rol `OrganizationAccountAccessRole`) o la guía detallada en [`terraform/aws/README.md`](terraform/aws/README.md).

---

## 🧩 Módulos Terraform

| Módulo | Función |
|--------|---------|
| `organizational-units` | Crea OUs Development y Production |
| `member-accounts` | Crea cuentas en la OU indicada |
| `service-control-policies` | Publica y adjunta SCPs |
| `platform-iam-user` | Usuario IAM en management |
| `iam-assume-member-roles` | Permite Switch role a cuentas hijas |

---

## 📚 Documentación adicional

- Detalle operativo, outputs y Switch role: **[`terraform/aws/README.md`](terraform/aws/README.md)**

---

## ⚠️ Notas

- No incluye **AWS Control Tower** ni landing zone completa; es un laboratorio de governance con Terraform.
- Los emails de las cuentas hijas deben ser **únicos** en AWS (p. ej. alias `+dev2`, `+production`).
- Revisa costos y límites de Organizations antes de crear cuentas en producción real.

---

<p align="center">
  <sub>🛠️ Proyecto educativo — AWS Governance</sub>
</p>

## TLAB5 — Budgeted Identity Architecture (Titan FinTech)

### 📘 Project Overview
Titan FinTech is a rapidly scaling startup facing two major risks: runaway cloud spending (“Denial of Wallet”) and insecure IAM practices. This project delivers a secure, cost‑controlled AWS foundation using Terraform. The architecture enforces strict financial discipline through an automated budget, applies least‑privilege IAM design, and deploys a compute instance that interacts safely with a private S3 vault. The workflow demonstrates responsible cloud provisioning, verification, and teardown as part of Titan’s security‑first engineering culture.

### 🛠️ Project Description
This Terraform configuration builds Titan FinTech’s core cloud identity and storage environment. It includes a $10 monthly AWS budget with email alerts at 80%, a private S3 vault bucket named dynamically with my initials, a custom IAM role that allows only `s3:PutObject` to that bucket, and an Ubuntu EC2 instance running with that role attached through an instance profile. The project concludes with a full `terraform destroy` to validate cost‑control compliance and complete the mission requirements.

## Included Artifacts

- **main.tf** — Terraform configuration
- **build_success.png** — Successful Terraform apply
- **security_audit.png** — IAM role attached to EC2 instance
- **destroy_verification.png** — Terraform destroy confirmation

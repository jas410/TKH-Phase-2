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

--

## TLAB6 — The Monitored Fortress (Titan FinTech)

### 📘 Project Overview
Titan FinTech is expanding into production, and the CISO requires a network that enforces Zero Trust access, captures full telemetry, and prevents all unauthorized inbound traffic. This project delivers a monitored, tightly controlled AWS environment using Terraform. The architecture includes a secure VPC perimeter, a public subnet with internet access, full VPC Flow Log monitoring, and a Zero Trust EC2 instance reachable only through AWS Systems Manager Session Manager. No inbound ports are opened at any point, demonstrating modern cloud security principles.

### 🛠️ Project Description
This Terraform configuration builds Titan FinTech’s production network from the ground up. It includes a 10.0.0.0/16 VPC, a public subnet, an Internet Gateway, and a route table enabling outbound internet access. The environment is fully monitored using a CloudWatch Log Group and VPC Flow Logs attached to the VPC, capturing all traffic for security analysis. A Zero Trust EC2 instance (Ubuntu, t2.micro) is deployed with **no ingress rules**, relying entirely on AWS Systems Manager for access. The instance uses the provided SSM instance profile, allowing secure browser‑based terminal access without exposing SSH or any inbound ports. The project concludes with a full `terraform destroy` to validate responsible teardown and cost discipline.

### Included Artifacts

- **main.tf** — Terraform configuration for the secure VPC, Flow Logs, and Zero Trust EC2  
- **ssm_terminal_proof.png** — Browser‑based SSM session showing `whoami` returning `ssm-user`  
- **cloudwatch_flow_logs.png** — CloudWatch Log Group confirming active VPC Flow Logs  
- **destroy_verification.png** — Terraform destroy confirmation showing all resources removed

## Troubleshooting Summary: OIDC Role Assumption Failures

During the setup of my automated Terraform pipeline, I encountered repeated GitHub Actions failures related to AWS OIDC authentication. Each workflow run failed with the message:

**“Not authorized to perform sts:AssumeRoleWithWebIdentity.”**

To resolve this, I went through a full set of troubleshooting steps to verify both GitHub and AWS configurations:

### ✔ GitHub Workflow Validation
- Confirmed the workflow triggers on the correct branch (`main`).
- Verified the role ARN was correct and fully included in the YAML file.
- Ensured required permissions were present (`id-token: write`, `contents: read`).
- Triggered fresh workflow runs using actual Git pushes rather than manual reruns.

### ✔ AWS IAM Role & Trust Policy Checks
- Verified the IAM role existed and matched the ARN used in the workflow.
- Confirmed the trust policy included the correct `sub` condition for my repo and branch.
- Added required OIDC conditions (`aud` and `iss`) to match GitHub’s token format.
- Ensured the OIDC identity provider was configured with the correct audience (`sts.amazonaws.com`).
- Checked that the role’s permissions policy allowed all necessary actions.

### ✔ Git & Identity Verification
- Confirmed my Git username and email matched my GitHub account (`jas410`).
- Verified no cached or incorrect credentials were stored locally.
- Ensured pushes were coming from the correct GitHub identity.

### ✔ Result
Despite multiple corrections and validations, the workflow continued to fail with the same OIDC authorization error. The attached screenshot shows the repeated attempts to assume the role before AWS ultimately rejects the request.




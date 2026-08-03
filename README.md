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



## TLAB 7 - Troubleshooting Summary: OIDC Role Assumption Failures

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


## MINI LABS: S19 — The Traveler’s Guide (Pipeline Lab)

### 📘 Project Overview
This mini‑lab introduces automated cloud governance through CI/CD. After a production outage caused by a manual deployment, Titan FinTech banned all local laptop deployments. As Lead DevSecOps Engineer, I implemented a GitHub Actions workflow that automatically validates Terraform code every time a team member pushes to the repository. This lab establishes the foundation for secure, repeatable, and fully remote infrastructure planning.

### 🛠️ Project Description
The S19 Pipeline Lab consists of two phases.  
In **Phase 1**, I repaired a sabotaged GitHub Actions YAML workflow (`pulse.yml`) by correcting indentation inside the `jobs` block. Once fixed, the workflow executed successfully and printed “Hello DevSecOps!” in the Actions console, confirming the runner was functioning.

In **Phase 2**, I expanded the automation by creating a `terraform-plan.yml` workflow that performs Terraform initialization and planning directly inside the GitHub runner. I injected AWS credentials as encrypted repository secrets, configured the HashiCorp Terraform setup action, and ensured the repository contained a valid `main.tf` so the plan could execute. Each push to `main` now triggers a remote Terraform plan, proving that infrastructure validation can occur without relying on local machines.

### 📁 S19 Artifacts
- `.github/workflows/pulse.yml` — Fixed YAML workflow  
- `.github/workflows/terraform-plan.yml` — Automated Terraform plan pipeline  
- `main.tf` — Minimal Terraform configuration for remote planning  
- `pipeline_success.png` — Screenshot of successful GitHub Actions run

## S20 — The Traveler’s Guide (Quality Lab)

### 📘 Project Overview
This mini‑lab introduces security quality gates through automated static analysis. After repeated incidents involving insecure S3 deployments, Titan FinTech mandated that all infrastructure code must pass a SAST scan before any pipeline can proceed. As the DevSecOps Engineer, I integrated tfsec into GitHub Actions to enforce secure-by-default Terraform practices. This lab demonstrates how Shift‑Left security prevents misconfigurations from ever reaching production.

### 🛠️ Project Description
The S20 Quality Lab is structured around intentional failure followed by remediation.  
In **Phase 1**, I cloned the lab repository and examined the sabotaged `main.tf` file, which contained an S3 bucket configured with `acl = "public-read"`. This violates cloud security policy and triggers tfsec findings. I created a GitHub Actions workflow (`tfsec-pipeline.yml`) using Aqua Security’s tfsec action to scan the repository on every push to `main`. After committing and pushing the vulnerable code, the pipeline correctly failed, displaying red status and detailed security violations such as public access exposure and missing encryption.

In **Phase 2**, I remediated the Terraform configuration based on tfsec’s findings. I removed the public ACL, added a `aws_s3_bucket_public_access_block` resource to enforce private access, and implemented server‑side encryption using `aws_s3_bucket_server_side_encryption_configuration`. After committing the fixes, the pipeline re-ran and passed successfully, proving that the quality gate now enforces secure infrastructure standards.

### 📁 S20 Artifacts
- `.github/workflows/tfsec-pipeline.yml` — SAST quality gate workflow  
- `main.tf` — Remediated secure S3 configuration  
- `pipeline_failure.png` — Screenshot of failed tfsec scan  
- `pipeline_success.png` — Screenshot of successful green quality gate

## S21 — The Traveler’s Guide (Delivery Lab)

### 📘 Project Overview
This mini‑lab focuses on modern, keyless cloud deployment using GitHub’s OIDC federation. Titan FinTech’s Security Operations Center issued a mandate to eliminate all long‑lived AWS Access Keys from GitHub Secrets. As the DevSecOps Engineer, I began establishing an OIDC trust relationship between GitHub Actions and AWS so Terraform deployments could authenticate dynamically without static credentials. This lab demonstrates the shift from secret‑based authentication to secure, short‑lived identity tokens.

### 🛠️ Project Description
The S21 Delivery Lab centers on building the OIDC “handshake” between GitHub and AWS.  
In **Phase 1**, I cloned the lab repository and created an OpenID Connect Identity Provider in AWS IAM using the official GitHub token endpoint. I then repaired the sabotaged `trust-policy.json`, tightening the `StringLike` condition so only my personal repository (`jas410/S21-Delivery-Lab`) and the `main` branch could assume the role. After replacing the placeholder AWS Account ID and repository string, I created a Web Identity IAM Role and attached temporary AdministratorAccess permissions for lab testing.

In **Phase 2**, I began constructing the keyless deployment pipeline. I removed all long‑lived AWS Access Keys from GitHub Secrets and created a new GitHub Actions workflow (`deploy.yml`) that uses `aws-actions/configure-aws-credentials` to authenticate via OIDC. The workflow included the required permissions block (`id-token: write`) and Terraform steps for initialization and apply. Although the pipeline did not fully succeed yet, the OIDC configuration and role trust relationship were correctly established, and the remaining work involves finalizing the role ARN and Terraform resource configuration.

### 📁 S21 Artifacts
- `trust-policy.json` — Corrected OIDC trust policy  
- `.github/workflows/deploy.yml` — Keyless Terraform deployment workflow  
- `main.tf` — Terraform configuration used for testing OIDC deployment  
- `oidc_attempt.png` — Screenshot of the pipeline attempt and authentication logs  
- `destroy_verification.png` — Screenshot of local `terraform destroy` proving teardown




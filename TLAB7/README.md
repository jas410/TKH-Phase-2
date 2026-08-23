# TLAB7 — The Automated Forge (Keyless + Scanned + Fully Automated Pipeline)

This capstone builds a complete DevSecOps pipeline for Titan FinTech using Terraform, GitHub Actions, OIDC federation, and tfsec scanning. The goal was to prove end‑to‑end mastery of keyless authentication, automated SAST quality gates, and continuous deployment.

---

## What I Built

### • OIDC Identity Provider + Trust Policy
I verified my GitHub OIDC provider in AWS IAM and created a role named **DevSecOps-Pipeline-Role**.  
I updated the trust policy to restrict access to my exact repo:


Then I configured Terraform’s backend to store its state file in that vault.

### • Unified 3‑Stage Pipeline (Authenticate ➜ Scan ➜ Deploy)
I built `.github/workflows/forge-pipeline.yml` combining:
- **OIDC authentication** (no AWS keys)
- **tfsec SAST scanning** (soft_fail = false)
- **Terraform apply -auto-approve**

This creates a fully automated, secure deployment pipeline.

### • Failure → Fix → Success Lifecycle
1. First push: pipeline fails at tfsec  
2. I read the logs and fixed the flagged issue (`aws-vpc-no-public-ingress-sgr`)  
3. Second push: pipeline passes and deploys the infrastructure

This demonstrates proper shift‑left remediation.

### • Teardown
I authenticated locally, re‑initialized Terraform with the S3 backend, and ran: 
repo:YourGitHubUsername/TLAB7-Forge:ref:refs/heads/main


This ensures only my pipeline can assume the role.

### • S3 State Vault
I created a permanent S3 bucket:


Then I configured Terraform’s backend to store its state file in that vault.

### • Unified 3‑Stage Pipeline (Authenticate ➜ Scan ➜ Deploy)
I built `.github/workflows/forge-pipeline.yml` combining:
- **OIDC authentication** (no AWS keys)
- **tfsec SAST scanning** (soft_fail = false)
- **Terraform apply -auto-approve**

This creates a fully automated, secure deployment pipeline.

### • Failure → Fix → Success Lifecycle
1. First push: pipeline fails at tfsec  
2. I read the logs and fixed the flagged issue (`aws-vpc-no-public-ingress-sgr`)  
3. Second push: pipeline passes and deploys the infrastructure

This demonstrates proper shift‑left remediation.

### • Teardown
I authenticated locally, re‑initialized Terraform with the S3 backend, and ran:





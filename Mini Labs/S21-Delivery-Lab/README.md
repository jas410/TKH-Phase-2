# S21 — Keyless OIDC Terraform Deployment (DevSecOps Lab)

This lab implements a secure, keyless Terraform deployment pipeline using GitHub Actions and AWS IAM OpenID Connect (OIDC). The Security Operations Center (SOC) mandated the removal of all long‑lived AWS Access Keys from GitHub Secrets, requiring a modern identity‑federated workflow. This project demonstrates how to establish an OIDC trust relationship and deploy infrastructure using short‑lived, automatically issued credentials.

---

## 📌 Lab Overview

Traditional CI/CD pipelines often rely on static AWS Access Keys stored in GitHub Secrets. These keys pose a major security risk if leaked or misconfigured.  
This lab replaces static credentials with **OIDC‑based, short‑lived tokens**, enabling secure, auditable, and ephemeral authentication for Terraform deployments.

The workflow includes:

1. **Creating an AWS OIDC Identity Provider**  
2. **Fixing a sabotaged IAM trust policy**  
3. **Creating a Web Identity IAM Role**  
4. **Building a keyless Terraform deployment pipeline**  
5. **Executing and destroying infrastructure using OIDC**

---

## 🧩 Phase 1 — The Handshake (OIDC Trust Setup)

- Clone the repository  
- Navigate into the project folder  
- Create an OIDC Identity Provider in AWS IAM  
- Add the GitHub OIDC provider:
  - URL: `https://token.actions.githubusercontent.com`
  - Audience: `sts.amazonaws.com`
- Fix the sabotaged `trust-policy.json`:
  - Restrict access to your exact repo:
    ```
    "repo:YourGitHubUsername/S21-Delivery-Lab:ref:refs/heads/main"
    ```
  - Replace the placeholder AWS Account ID with your real 12‑digit ID
- Create a Web Identity IAM Role using the OIDC provider  
- Attach `AdministratorAccess` (lab only)  
- Copy the Role ARN for pipeline use

This phase establishes the secure handshake between GitHub and AWS.

---

## 🧩 Phase 2 — The Keyless Deployment (Terraform via OIDC)

- Delete all long‑lived AWS Access Keys from GitHub Secrets  
- Create `.github/workflows/deploy.yml`  
- Add the required OIDC permissions block: permissions:
id-token: write
contents: read

- Configure AWS credentials

- Replace the `role-to-assume` value with your actual IAM Role ARN  
- Add Terraform initialization and apply steps  
- Ensure `main.tf` contains valid infrastructure (e.g., VPC, EC2, S3)  
- Commit and push to trigger the pipeline

---

## 🧩 Phase 3 — Submission Requirements

You must submit:

- **Screenshot A:** Successful GitHub Actions run showing expanded **Terraform Apply** logs  
- **Screenshot B:** Local terminal output after running: terraform destroy -auto-approve

- **Your corrected `trust-policy.json` file**

---

## 🛠️ Technologies Used

- AWS IAM (OIDC, Web Identity Roles)  
- GitHub Actions  
- Terraform (HCL)  
- aws-actions/configure-aws-credentials  
- YAML  
- Linux / Ubuntu  
- Git & Version Control

---


---

## 🔐 Security Notes

- All long‑lived AWS keys must be deleted  
- OIDC tokens are short‑lived and scoped to the workflow  
- GitHub Actions runners authenticate securely without secrets  
- IAM trust policies must be tightly scoped to specific repos and branches

---

## 🏁 Outcome

This lab demonstrates my ability to:

- Build secure, modern identity‑federated CI/CD pipelines  
- Replace static credentials with OIDC authentication  
- Deploy and destroy infrastructure using ephemeral tokens  
- Enforce SOC policies and cloud security best practices  
- Produce audit‑ready DevSecOps artifacts







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
- Add the required OIDC permissions block:

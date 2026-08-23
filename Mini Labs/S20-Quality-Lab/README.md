# S20 — Terraform Security Quality Gate (DevSecOps Lab)

This lab implements a security-focused GitHub Actions pipeline that automatically scans Terraform code for vulnerabilities using **tfsec**. The goal is to enforce shift-left security by blocking insecure infrastructure — specifically public S3 buckets — before they can be deployed.

---

## 📌 Lab Overview

A junior developer repeatedly attempted to deploy S3 buckets with `acl = "public-read"`, which violates cloud security best practices. To prevent this, a **SAST (Static Application Security Testing)** scanner was integrated into the CI/CD pipeline. The pipeline fails immediately if insecure Terraform configurations are detected.

This lab demonstrates how DevSecOps teams enforce guardrails and prevent misconfigurations from ever reaching AWS.

---

## 🧩 Phase 1 — Intentional Failure (Testing the Security Gate)

- Clone the repository  
- Inspect the sabotaged `main.tf` containing a public S3 bucket  
- Create `.github/workflows/tfsec-pipeline.yml`  
- Add the Aqua Security tfsec GitHub Action  
- Push the vulnerable code to trigger a **RED** pipeline failure  
- Review tfsec findings such as:
  - `aws-s3-no-public-access-block`
  - `aws-s3-encryption-customer-key`
  - `aws-s3-enable-versioning`

This phase proves the quality gate correctly blocks insecure infrastructure.

---

## 🧩 Phase 2 — Remediation & Passage

- Remove the insecure `acl = "public-read"` line  
- Add secure Terraform resources:
  - `aws_s3_bucket_public_access_block`
  - `aws_s3_bucket_server_side_encryption_configuration`
  - Enable versioning  
- Commit and push the remediated code  
- Observe the pipeline turn **GREEN** once tfsec detects no vulnerabilities

This phase demonstrates secure cloud engineering and proper remediation workflow.

---

## 🧩 Phase 3 — Submission Requirements

You must submit:

- **Screenshot A:** Failed pipeline run showing tfsec errors  
- **Screenshot B:** Successful pipeline run after remediation  
- **Your secured `main.tf` file**

These artifacts prove the full shift-left lifecycle:  
**Detection → Failure → Remediation → Secure Deployment**

---

## 🛠️ Technologies Used

- **Terraform (HCL)**  
- **GitHub Actions (CI/CD)**  
- **tfsec (Static Analysis)**  
- **AWS S3 Security Controls**  
- **YAML**  
- **Linux / Ubuntu**  
- **Git & Version Control**

---


---

## 🔐 Security Notes

- Public S3 buckets are prohibited  
- All scans run automatically on every push to `main`  
- The pipeline enforces secure-by-default cloud infrastructure  
- tfsec acts as a mandatory quality gate for Terraform deployments

---

## 🏁 Outcome

This lab demonstrates your ability to:

- Integrate SAST scanning into CI/CD  
- Detect insecure cloud configurations  
- Remediate vulnerabilities using AWS best practices  
- Enforce shift-left security in Terraform workflows  
- Build production-grade DevSecOps guardrails

Perfect for showcasing in a **Cloud Security Architect** or **DevSecOps Engineer** portfolio.


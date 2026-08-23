# S19 – Automated Terraform Deployment Pipeline (DevSecOps Lab)

This project implements a secure, automated GitHub Actions pipeline that runs a Terraform deployment plan every time code is pushed to the repository. The lab simulates a real-world DevSecOps scenario where local deployments are banned after a production outage, requiring all infrastructure changes to be validated and executed through CI/CD.

## 📌 Lab Overview

The pipeline performs two major functions:

1. **First Pulse Workflow**  
   A YAML-based GitHub Actions workflow that validates correct syntax, indentation, and job structure. Once fixed, the workflow prints `"Hello DevSecOps!"` to confirm successful execution.

2. **Terraform Remote Planning Workflow**  
   A secure Terraform pipeline using GitHub Actions + AWS secrets to remotely initialize and plan infrastructure. This ensures all deployments follow least‑privilege, auditable, cloud‑native standards.

---

## 🧩 Phase 1 — The First Pulse

- Clone the lab repository  
- Navigate into the project folder  
- Fix the sabotaged YAML indentation inside `.github/workflows/pulse.yml`  
- Commit and push the fix  
- Verify the workflow run in GitHub Actions

This phase ensures you understand YAML structure, job blocks, and GitHub Actions execution flow.

---

## 🧩 Phase 2 — Remote Terraform Planning

- Inject AWS credentials as GitHub Actions secrets  
- Create `.github/workflows/terraform-plan.yml`  
- Add the official HashiCorp Terraform setup action  
- Run `terraform init` and `terraform plan` remotely  
- Ensure the repo contains a valid `main.tf` with an AWS provider and resource

This phase demonstrates secure, automated cloud provisioning without local machines.

---

## 🧩 Phase 3 — Submission

- Capture a screenshot of the successful Terraform Plan workflow  
- Expand the “Terraform Plan” step to show the planned infrastructure  
- Upload the screenshot and fixed YAML file to Canvas

---

## 🛠️ Technologies Used

- **GitHub Actions** (CI/CD automation)  
- **Terraform (HCL)**  
- **AWS IAM, EC2, S3**  
- **YAML**  
- **Linux / Ubuntu**  
- **Git & Version Control**

---

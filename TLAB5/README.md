# TLAB5 — Budgeted Identity (Titan FinTech)

This lab builds Titan FinTech’s foundational AWS architecture using Terraform with strict cost controls and least‑privilege IAM design. The goal was to prevent overspending (“Denial of Wallet”) and avoid security breaches caused by wildcard IAM policies.

---

## What I Did

### • Created a $10 Monthly AWS Budget
I added an `aws_budgets_budget` resource with an email alert at 80% usage to enforce cost limits.

### • Built a Private S3 Vault
I created a private S3 bucket named dynamically with my initials using Terraform interpolation:

### • Designed a Least‑Privilege IAM Role
I created **Titan-EC2-Vault-Role** with:
- A trust policy allowing only EC2 to assume it  
- A custom IAM policy allowing **only s3:PutObject**  
- The policy scoped strictly to my bucket ARN using interpolation (no hardcoding)

### • Deployed an EC2 Instance Wearing the Role
I launched a **t2.micro Ubuntu EC2 instance** and attached the IAM role using an instance profile.

### • Validated and Destroyed the Infrastructure
I ran:
- `terraform apply` → captured successful build  
- Verified the EC2 instance + role in the AWS Console  
- `terraform destroy` → captured teardown output  

---

## How I Did It

1. Cloned the starter repo and ran `terraform init`  
2. Added the AWS Budget resource  
3. Created a private S3 bucket with dynamic naming  
4. Built a least‑privilege IAM role + policy  
5. Attached the role to an EC2 instance  
6. Applied the infrastructure and verified it in AWS  
7. Destroyed the environment to avoid charges  

---

## Technologies Used

- Terraform (HCL)  
- AWS IAM  
- AWS Budgets  
- AWS S3  
- AWS EC2  
- JSON IAM Policies  

---

## Outcome

This lab demonstrates secure Terraform architecture design, cost governance, and least‑privilege IAM enforcement — key skills for Cloud Security Architect and DevSecOps roles.


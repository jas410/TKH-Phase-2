# TLAB5 — Budgeted Identity (Terraform AWS Architecture)

This lab builds a secure, cost‑controlled AWS environment for “Titan FinTech” using Terraform. The goal was to prevent overspending (“Denial of Wallet”) and enforce strict least‑privilege security after a breach caused by a wildcard IAM policy. The project includes a budget firewall, a private S3 vault, a surgical IAM role, and an EC2 instance that uses that role.

---

## 📌 What I Built

### 1. AWS Budget Firewall
I created an `aws_budgets_budget` resource with:
- A **hard monthly limit of $10.00**
- An email alert at **80% usage**
This ensures Titan FinTech cannot accidentally overspend.

### 2. Private S3 Storage Vault
I built a private S3 bucket named dynamically using my initials:

# TLAB5 — Budgeted Identity (Titan FinTech)

This lab builds Titan FinTech’s foundational AWS architecture using Terraform with strict cost controls and least‑privilege IAM design. The goal was to prevent overspending (“Denial of Wallet”) and avoid security breaches caused by wildcard IAM policies.

---

## What I Did

### • Created a $10 Monthly AWS Budget
I added an `aws_budgets_budget` resource with an email alert at 80% usage to enforce cost limits.

### • Built a Private S3 Vault
I created a private S3 bucket named dynamically with my initials using Terraform interpolation:

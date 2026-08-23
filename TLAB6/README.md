# TLAB6 — Monitored Fortress (Secure VPC + Zero Trust EC2)

This lab builds Titan FinTech’s production network using Terraform. The goal was to create a secure VPC, enable full traffic monitoring with VPC Flow Logs, and deploy a Zero Trust EC2 instance reachable only through AWS Systems Manager — with **no inbound ports** allowed.

---

## What I Built

### • Secure VPC Perimeter
I created:
- A VPC: `10.0.0.0/16`
- A public subnet: `10.0.1.0/24`
- An Internet Gateway
- A route table sending `0.0.0.0/0` to the IGW  
- A route table association attaching the public subnet

This provides controlled internet access for the instance.

### • VPC Flow Logs “Wiretap”
I added:
- A CloudWatch Log Group: `/tkh/titan-prod-vpc-logs` (1‑day retention)
- A Flow Log capturing **ALL** traffic  
- The Flow Log used the provided IAM role via:


The instance is reachable **only** through AWS Systems Manager Session Manager — no SSH, no public ports.

---

## How I Did It

1. Cloned the starter repo and ran `terraform init`  
2. Added VPC, subnet, IGW, route table, and association  
3. Added CloudWatch Log Group + VPC Flow Logs  
4. Created Zero Trust security group  
5. Deployed EC2 instance with SSM profile  
6. Ran `terraform apply` and connected via Session Manager  
7. Verified:
 - `whoami` returned `ssm-user`
 - Flow Logs were active in CloudWatch  
8. Ran `terraform destroy` and captured the teardown screenshot  

---

## Technologies Used

- Terraform (HCL)  
- AWS VPC  
- AWS CloudWatch Logs  
- AWS Flow Logs  
- AWS EC2  
- AWS Systems Manager (SSM)  
- Zero Trust Security Groups  

---

## Outcome

This lab demonstrates secure network design, full traffic monitoring, and Zero Trust compute deployment — key skills for Cloud Security Architect and DevSecOps roles.

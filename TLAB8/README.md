# TLAB 8: Fleet Auditor — Container Security & Serverless Automation

## 📘 Overview
This project demonstrates a complete container security workflow using **Docker**, **AWS Elastic Container Registry (ECR)**, **IAM least‑privilege policies**, and a **Lambda-based audit function**. The objective of the lab was to build and harden a container image, push it to ECR, trigger a vulnerability scan, and automate an audit of the repository using a Lambda function with restricted permissions.

This repository includes:
- A hardened Dockerfile  
- The IAM least‑privilege policy (`auditor-role.json`)  
- Screenshots of the ECR vulnerability scan  
- Screenshots of the Lambda audit logs  

---

## 🎯 Objectives

### 1. Container Hardening
A minimal, secure Docker image was created using:
- `node:alpine` as the lightweight base image  
- A non‑root user (`USER node`)  
- No unnecessary dependencies  

This approach reduces the attack surface and aligns with container security best practices.

---

### 2. Vulnerability Scanning in ECR
After building the image locally, it was:
1. Tagged  
2. Authenticated to ECR  
3. Pushed to a private repository  
4. Scanned for vulnerabilities  

AWS ECR automatically scanned the ARM64 manifest of the image, producing a clean report with **zero critical, high, medium, low, or informational vulnerabilities**.

A screenshot of the scan results is included in this repository.

---

### 3. IAM Least‑Privilege Access
A custom IAM policy was created to ensure the Lambda function could **only** perform the actions required:

- Write logs to CloudWatch  
- Read image metadata from ECR  

Nothing more.

This policy was attached to a dedicated IAM role (`FleetAuditor-Role`) used exclusively by the Lambda function.

The policy file (`auditor-role.json`) is included in this repository.

---

### 4. Serverless Audit Automation (Lambda)
A Python Lambda function was created to automatically audit the ECR repository by calling:

```python
client.describe_images(repositoryName='tkh-fleet-vault')

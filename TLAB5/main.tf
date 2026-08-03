terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Random ID for unique naming
resource "random_id" "id" {
  byte_length = 4
}

# Step 2 — Budget: $10/month with email at 80%
resource "aws_budgets_budget" "monthly_budget" {
  name              = "titan-fintech-monthly-budget"
  budget_type       = "COST"
  limit_amount      = "10"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  cost_filters = {
    "Service" = "Amazon Elastic Compute Cloud - Compute"
  }

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"

    subscriber_email_addresses = [
      "adamsjasmine132@gmail.com"
    ]
  }
}

# Step 3 — Secure S3 vault (private by default)
resource "aws_s3_bucket" "vault" {
  bucket = "titan-fintech-vault-jas-${random_id.id.hex}"

  tags = {
    Name        = "Titan FinTech Vault"
    Environment = "TLAB5"
  }
}

resource "aws_s3_bucket_acl" "vault_acl" {
  bucket = aws_s3_bucket.vault.id
  acl    = "private"
}

# Step 4 — IAM role for EC2 with least privilege
data "aws_iam_policy_document" "ec2_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "titan_ec2_vault_role" {
  name               = "Titan-EC2-Vault-Role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}

# IAM policy: only s3:PutObject to this specific bucket
data "aws_iam_policy_document" "vault_put_only" {
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.vault.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "vault_put_policy" {
  name   = "Titan-Vault-PutOnly-Policy"
  policy = data.aws_iam_policy_document.vault_put_only.json
}

resource "aws_iam_role_policy_attachment" "vault_role_attach" {
  role       = aws_iam_role.titan_ec2_vault_role.name
  policy_arn = aws_iam_policy.vault_put_policy.arn
}

# Step 5 — Instance profile to attach role to EC2
resource "aws_iam_instance_profile" "titan_instance_profile" {
  name = "Titan-EC2-Vault-Instance-Profile"
  role = aws_iam_role.titan_ec2_vault_role.name
}

# Ubuntu EC2 instance (t2.micro Free Tier)
resource "aws_instance" "titan_ec2" {
  ami           = "ami-0fc5d935ebf8bc3bc" # Ubuntu 22.04 in us-east-1 (update if needed)
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.titan_instance_profile.name

  tags = {
    Name        = "Titan FinTech Vault EC2"
    Environment = "TLAB5"
  }
}

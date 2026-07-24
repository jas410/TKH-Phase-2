provider "aws" {
  region = "us-east-1"
}

# ============================
# PERIMETER — VPC + SUBNET + IGW + ROUTES
# ============================

resource "aws_vpc" "titan_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "titan-prod-vpc"
  }
}

resource "aws_subnet" "titan_public_subnet" {
  vpc_id                  = aws_vpc.titan_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "titan-public-subnet"
  }
}

resource "aws_internet_gateway" "titan_igw" {
  vpc_id = aws_vpc.titan_vpc.id

  tags = {
    Name = "titan-igw"
  }
}

resource "aws_route_table" "titan_public_rt" {
  vpc_id = aws_vpc.titan_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.titan_igw.id
  }

  tags = {
    Name = "titan-public-rt"
  }
}

resource "aws_route_table_association" "titan_public_rta" {
  subnet_id      = aws_subnet.titan_public_subnet.id
  route_table_id = aws_route_table.titan_public_rt.id
}

# ============================
# WIRETAP — CLOUDWATCH LOG GROUP + VPC FLOW LOGS
# ============================

resource "aws_cloudwatch_log_group" "titan_vpc_logs" {
  name              = "/tkh/titan-prod-vpc-logs"
  retention_in_days = 1
}

resource "aws_flow_log" "titan_flow_logs" {
  vpc_id               = aws_vpc.titan_vpc.id
  log_destination      = aws_cloudwatch_log_group.titan_vpc_logs.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"

  # IAM role already exists in iam_provided.tf
  iam_role_arn = aws_iam_role.flow_log_role.arn

  tags = {
    Name = "titan-vpc-flow-logs"
  }
}

# ============================
# ZERO TRUST COMPUTE — SG + EC2 (SSM ONLY)
# ============================

resource "aws_security_group" "titan_zero_trust_sg" {
  name        = "titan-zero-trust-sg"
  description = "Zero Trust SG - no inbound, all outbound"
  vpc_id      = aws_vpc.titan_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "titan_ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.titan_public_subnet.id
  vpc_security_group_ids = [aws_security_group.titan_zero_trust_sg.id]

  # Instance profile already exists in iam_provided.tf
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "titan-zero-trust-ec2"
  }
}

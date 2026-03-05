# Terraform AWS Multi-AZ ALB + Auto Scaling Infrastructure

This project demonstrates a production-style, highly available AWS infrastructure built using Terraform.  

It provisions a scalable web application architecture using:

- VPC with public subnets across multiple Availability Zones
- Internet Gateway & Route Tables
- Security Groups
- Launch Template
- Auto Scaling Group (ASG)
- Application Load Balancer (ALB)
- Target Group with Health Checks
- Ubuntu EC2 instances running Nginx
- Dynamic Instance Private IP display

---

##  Architecture Overview

Internet  
↓  
Application Load Balancer (ALB)  
↓  
Target Group  
↓  
Auto Scaling Group (ASG)  
↓  
EC2 Instances (Ubuntu + Nginx)  
↓  
VPC (Multi-AZ Public Subnets)

This setup ensures high availability, scalability, and fault tolerance.

---

##  Technologies Used

- Terraform
- AWS EC2
- AWS VPC
- AWS Application Load Balancer (ALB)
- AWS Auto Scaling Group (ASG)
- Ubuntu Server
- Nginx

---

##  Infrastructure Components

### 1️ VPC Module
- Custom VPC
- 2 Public Subnets (Multi-AZ)
- Internet Gateway
- Route Tables
- Route Table Associations

### 2️ Security Groups
- ALB Security Group (Allows HTTP from Internet)
- EC2 Security Group (Allows HTTP traffic)

### 3️ Launch Template
- Ubuntu AMI
- Instance type: t3.micro
- User data script to:
  - Install Nginx
  - Start & enable service
  - Fetch Instance Private IP from EC2 metadata
  - Display IP in web page

### 4️ Auto Scaling Group
- Min: 1
- Desired: 2
- Max: 3
- Distributed across multiple AZs
- Attached to Target Group

### 5️ Application Load Balancer
- Internet-facing
- HTTP Listener (Port 80)
- Forwards traffic to Target Group
- Performs health checks

---

## How It Works

1. User accesses ALB DNS URL.
2. ALB distributes traffic across healthy EC2 instances.
3. Each instance runs Nginx.
4. The webpage dynamically displays the instance's private IP.
5. Refreshing the page shows different IPs, proving load balancing works.

---

## Key Learnings & Concepts Implemented

- Infrastructure as Code (IaC) using Terraform
- Modular Terraform structure
- Multi-AZ High Availability setup
- Launch Templates & Auto Scaling
- ALB + Target Group integration
- Health check debugging
- IMDSv2 metadata token handling
- Ubuntu package management (apt vs yum differences)
- 502 Bad Gateway troubleshooting
- Security Group configuration best practices

---

## ▶️ How to Deploy

### 1. Initialize Terraform

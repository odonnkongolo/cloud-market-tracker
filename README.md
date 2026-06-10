# Cloud-Native Market Tracker: AWS EKS & Terraform Deployment

## 🏗️ Architecture Overview
This repository contains the infrastructure and application code for a containerized Market Tracker application. The project demonstrates modern Platform Engineering principles by completely decoupling the application logic from the underlying infrastructure using **Docker**, **Terraform**, and **Amazon EKS (Kubernetes)**.

## 🚀 Tech Stack
* **Application Layer:** Python 3.10, Streamlit, Pandas
* **Containerization:** Docker, Amazon ECR
* **Infrastructure as Code (IaC):** Terraform
* **Compute & Orchestration:** Amazon EKS, EC2 Worker Nodes
* **Networking:** AWS VPC, Public/Private Subnets, NAT Gateway

## 📂 Repository Structure
The repository is split into two strict operational domains to maintain separation of concerns:

* `/app`: Contains the Python source code, dependencies, and the `Dockerfile`.
* `/infrastructure`: Contains the declarative HCL configurations to build the AWS network and Kubernetes cluster.

## 🔒 Security & Networking SRE Mechanics
This environment is built with strict security and high availability in mind:
1. **Private Compute:** Kubernetes worker nodes are strictly isolated within private subnets. They cannot be accessed directly from the public internet.
2. **NAT Gateway Routing:** Outbound traffic for node updates is securely routed through a NAT Gateway.
3. **Automated Vulnerability Scanning:** The Amazon ECR registry is configured via Terraform to automatically scan the Docker image for CVEs upon push.

## ⚙️ Deployment Runbook
To spin up this infrastructure from scratch:

1. **Build and Push the Container:**
   ```bash
   cd app
   docker build -t market-tracker-app .
   aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.eu-west-1.amazonaws.com
   docker tag market-tracker-app:latest <AWS_ACCOUNT_ID>[.dkr.ecr.eu-west-1.amazonaws.com/market-tracker-app:latest](https://.dkr.ecr.eu-west-1.amazonaws.com/market-tracker-app:latest)
   docker push <AWS_ACCOUNT_ID>[.dkr.ecr.eu-west-1.amazonaws.com/market-tracker-app:latest](https://.dkr.ecr.eu-west-1.amazonaws.com/market-tracker-app:latest)
   Provision the AWS Infrastructure:

2. **Build and Push the Container:**
   '''Bash
   cd infrastructure
   terraform init
   terraform apply

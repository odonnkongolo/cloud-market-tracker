# Cloud-Native Market Tracker: AWS EKS & DevSecOps Deployment + Grafana Observability

## 🏗️ Architecture Overview
This repository contains the infrastructure, application code, and CI/CD automation for a containerized Market Tracker application. The project demonstrates modern Platform Engineering principles by completely decoupling the application logic from the underlying infrastructure using **Docker**, **Terraform**, **Amazon EKS (Kubernetes)**, and **GitHub Actions**.

## 🚀 Tech Stack
* **Application Layer:** Python 3.10, Streamlit, Pandas
* **Containerization:** Docker, Amazon ECR
* **Infrastructure as Code (IaC):** Terraform
* **Compute & Orchestration:** Amazon EKS, EC2 Worker Nodes, Kubernetes Manifests
* **Networking:** AWS VPC, Public/Private Subnets, NAT Gateway, Network Load Balancer (NLB)
* **DevSecOps Pipeline:** GitHub Actions, Ruff, Bandit, TFLint, Trivy

## 📂 Repository Structure
The repository is strictly isolated into distinct operational domains:

* `/.github/workflows`: Contains the automated CI/CD pipeline YAML.
* `/app`: Contains the Python source code, dependencies, and the `Dockerfile`.
* `/infrastructure`: Contains the declarative HCL configurations to build the AWS network and Kubernetes cluster.
* `/kubernetes`: Contains the deployment and load balancer service manifests.

## 🔒 SRE & DevSecOps Mechanics
This environment is built with strict security, high availability, and shift-left testing in mind:
1. **Automated Security Gates:** Every push to `main` triggers a Directed Acyclic Graph (DAG) pipeline. Python code is linted and scanned for hardcoded secrets (Ruff/Bandit), while infrastructure and containers are scanned for CVEs (TFLint/Trivy) before deployment is permitted.
2. **Private Compute:** Kubernetes worker nodes are strictly isolated within private subnets. They cannot be accessed directly from the public internet.
3. **NAT Gateway Routing:** Outbound traffic for node updates is securely routed through a NAT Gateway.
4. **Modern Access API:** The EKS cluster utilizes the modern `API_AND_CONFIG_MAP` authentication mode, allowing secure, programmatic IAM access for the GitHub runner.

## ⚙️ Deployment Runbook
This infrastructure is designed for automated continuous delivery. To spin up the environment from scratch:

**1. Provision the AWS Infrastructure:**
Deploy the VPC, NAT Gateway, ECR registry, and EKS cluster via Terraform.
```bash
cd infrastructure
terraform init
terraform apply
```

**2. Push to `main` to trigger the pipeline** — GitHub Actions will build, scan, and deploy automatically.

---

## 📸 Screenshots

![CI/CD Pipeline — Ruff, Bandit, TFLint & Trivy security gates](screenshots/Screenshot%202026-06-11%20at%2014.34.00.png)

![EKS Cluster & Node Group provisioned via Terraform](screenshots/Screenshot%202026-06-11%20at%2015.02.09.png)

![Live application running on Kubernetes via Network Load Balancer](screenshots/Screenshot%202026-06-11%20at%2015.06.34.png)

---

## 📊 Observability Stack (Prometheus & Grafana)

To monitor real-time cluster and pod utilisation, a full observability stack is deployed via Helm into an isolated `monitoring` namespace using the community `kube-prometheus-stack` chart.

**Install the stack:**
```bash
# Add the community Helm chart repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Deploy Prometheus + Grafana into their own namespace
helm install kube-prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

**Access Grafana locally via a secure port-forward tunnel (no load balancer cost):**
```bash
# Retrieve the auto-generated admin password
kubectl get secret --namespace monitoring kube-prometheus-grafana \
  -o jsonpath="{.data.admin-password}" | base64 --decode; echo

# Forward the Grafana service to localhost
kubectl port-forward --namespace monitoring svc/kube-prometheus-grafana 8080:80
```

Open your browser at **http://localhost:8080** and log in with username `admin` and the password retrieved above.

### 📸 Grafana Dashboards

![Grafana — Pod CPU & memory utilisation metrics](screenshots/grafana1.png)

![Grafana — Kubernetes cluster overview dashboard](screenshots/grafana.png)

![Grafana — Node-level resource consumption](screenshots/grafana2.png)

🌐 Overview

This repository hosts the source code for my personal portfolio website, built with Flask and deployed on a fully automated AWS containerized architecture.

The entire infrastructure is deployed using Terraform, and updates are shipped via GitHub Actions, which build and push new Docker images to Amazon ECR and redeploy the ECS Fargate service behind an Application Load Balancer (ALB).

📐 Architecture Diagram
🔥 Tech Stack
Layer	Technology	Purpose
Frontend/Backend	Flask	Serves portfolio pages + API endpoints
Containerization	Docker	Packages app for reliable deployment
Infrastructure	Terraform	IaC provisioning (ECS, ALB, VPC, IAM, ECR)
Deployment	GitHub Actions	CI/CD pipeline on push to main
Compute	AWS ECS Fargate	Serverless container hosting
Registry	AWS ECR	Stores versioned Docker images
Networking	ALB + VPC	Routes/secure traffic to private tasks
🏗️ How the System Works
1. Local Development

Flask app runs on your machine

Tested using Python virtual environment or Docker

2. GitHub Repository

Stores Flask code

Dockerfile + Terraform configs included

GitHub Actions workflow monitors main branch

3. Terraform Deployment

Creates all cloud resources:

VPC, subnets, routing

ECR repo

ECS cluster, tasks, service

ALB + listeners + target group

IAM roles

OIDC role for GitHub Actions authentication

Security groups & networking

(Optional) S3 + DynamoDB for Terraform state

4. CI/CD Pipeline (GitHub Actions)

Builds Docker image

Tags with latest + commit SHA

Pushes image to ECR

Updates ECS Task Definition

Forces graceful rolling deployment

5. Application Load Balancer

Receives inbound traffic

Health checks containers

Forwards traffic only to healthy tasks

Protects private subnets

🧪 Local Development
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py


Or using Docker:

docker build -t portfolio .
docker run -p 8000:8000 portfolio

🔄 CI/CD Workflow Summary
- Build Docker image  
- Authenticate to AWS with OIDC  
- Push to ECR  
- Register new Task Definition  
- Deploy updated service to ECS  


This guarantees zero-downtime deployments and fully automated updates.

📁 Repository Structure
/
├── app/                     # Flask application
├── Dockerfile               # Container definition
├── requirements.txt
├── terraform/               # IaC modules
│   ├── main.tf
│   ├── vpc.tf
│   ├── ecs.tf
│   ├── alb.tf
│   ├── iam.tf
│   └── variables.tf
├── .github/workflows/
│   └── deploy.yml           # CI/CD pipeline
└── README.md

👨‍💻 Author

Brandon Brinson
Cloud Engineer | AWS | DevOps | Python | Linux
📧 email
🌐 portfolio link
🔗 linkedin link

✅ VERSION 2 — RECRUITER-FOCUSED READ ME (BUSINESS VALUE + IMPACT)

(Clear, achievement-driven, communicates professional skill sets)

**Brandon’s Cloud-Native Portfolio Platform

Built with Flask, AWS, Docker, Terraform & Automated CI/CD**

This project demonstrates my ability to design, build, automate, and maintain cloud-native applications using modern DevOps and AWS best practices. It showcases real-world skills required for roles in:

Cloud Engineering

DevOps / Site Reliability Engineering

Infrastructure Automation

Platform Engineering

Backend Engineering (Python)

⭐ What This Project Demonstrates
✔ Infrastructure-as-Code Expertise

All infrastructure — VPC, ALB, ECS Cluster, Task Definitions, IAM, ECR — is provisioned using Terraform, following production-grade patterns.

✔ Secure & Automated CI/CD Pipeline

Code pushes automatically trigger a GitHub Actions pipeline that:

Builds and tags a Docker image

Uploads it to ECR

Updates the ECS Task Definition

Triggers a rolling deployment in ECS Fargate

Uses OIDC, eliminating AWS access keys

This shows I can manage secure, scalable delivery pipelines.

✔ Production-Grade Containerized Deployment

The portfolio app runs inside ECS Fargate, demonstrating experience with:

Container orchestration

Serverless compute

Scaling strategies

Load balancing

Networking & IAM separation

Health checks

✔ Strong Python Backend Skills

The backend portfolio is a Flask API-driven web application, packaged into a production Docker container (with Gunicorn).

🏗️ High-Level Architecture (Recruiter-Friendly)

User visits domain
→ Routed through Application Load Balancer

ALB routes request
→ To ECS Fargate service running in private subnet

ECS container hosts Flask app
→ Pulls image from ECR

Updates deployed automatically
→ GitHub Actions CI/CD

Infrastructure repeatable
→ Terraform modules define all resources

🛠️ Skills Demonstrated in This Project
Cloud (AWS)

✔ ECS Fargate
✔ ECR
✔ ALB
✔ VPC networking & subnets
✔ IAM roles/policies
✔ Terraform state mgmt (S3 + DynamoDB)

DevOps & IaC

✔ Terraform modules
✔ GitHub Actions CI/CD
✔ Docker multi-stage builds
✔ Infrastructure version control
✔ Zero-downtime deployments

Backend Engineering

✔ Flask application structure
✔ API design
✔ Environment management
✔ Logging, health checks, and configuration

Security

✔ AWS OIDC federation
✔ Private subnets for ECS tasks
✔ Least-privilege IAM roles
✔ No hard-coded credentials

📈 Why This Project Matters (Recruiter Summary)

This project is a production-ready cloud deployment, not a simple demo. It shows I can:

Build and deploy containerized apps

Architect AWS-based infrastructure

Automate deployments securely

Manage source control and pipelines

Implement scalable, fault-tolerant services

Write clean Python backend code

Operate in a modern DevOps environment

It represents the same workflow used by most enterprise engineering teams.

📞 Let’s Connect

Brandon Brinson
Cloud Engineer | Systems | DevOps | Python | AWS
📧 email
🌐 portfolio
🔗 LinkedIn

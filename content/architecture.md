---
title: "Infrastructure Architecture"
draft: false
description: "An overview of the cloud-native infrastructure and CI/CD pipeline powering this portfolio."
---

The foundation of this website is not merely a collection of HTML files, but a fully automated, cloud-native infrastructure deployed on AWS, utilizing modern DevOps best practices. 

The core architectural principle driving this project is **maximum security coupled with complete automation**.

## 🏗️ Infrastructure as Code (IaC)
The entire infrastructure is provisioned and managed as code using **Terraform**, ensuring a reproducible, consistent, and scalable environment.

* **Compute:** The application runs on an Amazon Linux 2023 EC2 instance (t3.micro).
* **Network & Security:** The instance resides within a strictly isolated **Private Subnet** of an AWS VPC. It lacks a public IPv4 address, and inbound SSH access (port 22) is completely disabled to eliminate external attack vectors.
* **Routing:** Outbound internet connectivity is facilitated exclusively via IPv6 through an Egress-Only Internet Gateway, preventing any uninitiated inbound traffic.
* **Web Server:** A lightweight Nginx server handles the efficient delivery of static assets.

The reason for choosing an EC2-based architecture over S3+CloudFront is described below in the **Architectural Trade-offs & Design Decisions** section.

{{<infra-animation>}}

### 🚀 CI/CD Pipeline (GitHub Actions)
The deployment process is fully automated. Any code pushed to the `main` branch triggers the following Continuous Integration and Continuous Deployment (CI/CD) workflow:

1.  **Build:** A GitHub Actions runner is provisioned to check out the source code and compile the static site using the Hugo framework.
2.  **Package:** The compiled site is compressed into an immutable artifact (`site.zip`).
3.  **Delivery (AWS S3):** The artifact is securely uploaded to a private Amazon S3 bucket, governed by strict IAM policies.
4.  **Remote Execution (AWS SSM):** The pipeline dispatches a deployment command via the AWS Systems Manager (SSM) API.
5.  **Atomic Update:** The SSM Agent, operating securely within the isolated EC2 instance, retrieves the artifact from S3 via the internal IPv6 network and executes an atomic directory swap for Nginx, ensuring a zero-downtime deployment.

{{<deploy-animation>}}

## ⚖️ Architectural Trade-offs & Design Decisions
While hosting a static website via Amazon S3 paired with Amazon CloudFront (CDN) is the industry-standard, serverless approach, this project deliberately employs an EC2-based architecture. 

This decision was driven by two primary factors:
1. **Cost Optimization:** This specific architecture ensures the entire infrastructure and CI/CD pipeline operate completely free of charge, staying strictly within the AWS Free Tier limits.
2. **Skill Demonstration:** Provisioning a private VPC, configuring a Linux web server from scratch, and orchestrating a secure, pull-based deployment pipeline via AWS SSM serves as a practical demonstration of broader systems engineering, networking, and security competencies. It highlights a deep understanding of core AWS services beyond simple serverless static hosting.

### 🔐 Security & Principle of Least Privilege (PoLP)

This architecture rigorously enforces the Principle of Least Privilege:

* The EC2 instance is granted read-only access restricted entirely to the specific S3 artifact bucket.

* The GitHub Actions runner utilizes an inline IAM policy that permits `s3:PutObject` operations only on the designated artifact prefix, and restricts `ssm:SendCommand` execution strictly to instances bearing the `portfolio-web-instance` resource tag.
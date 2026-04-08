# Cloud & DevOps Engineering Portfolio

This repository contains the source code, infrastructure definitions, and deployment pipelines for my personal portfolio website. 

Rather than just hosting a standard static site, this project is engineered as a comprehensive demonstration of cloud architecture, Infrastructure as Code (IaC), CI/CD automation, and network security.

## 🏗️ Architecture & Infrastructure

While a standard Hugo site is typically hosted via S3 and CloudFront, this project deliberately utilizes a more complex, server-based AWS architecture to demonstrate broader systems engineering and networking competencies while remaining strictly within the AWS Free Tier.

* **Edge & DNS:** Cloudflare (CDN, WAF, Flexible SSL/TLS).
* **Network Isolation:** AWS VPC with Public and Private Subnets, Internet Gateway, and Egress-Only Internet Gateway (IPv6).
* **Compute & Routing:** Amazon Linux 2023 EC2 instance hidden in a Private Subnet, with traffic routed via an Application Load Balancer (ALB) in the Public Subnet.
* **Infrastructure as Code:** The entire AWS environment is provisioned and managed using **Terraform**.
* **Security:** Strict adherence to the Principle of Least Privilege (PoLP) using inline IAM policies and strict Security Group rules.

## 🚀 CI/CD Pipeline

The deployment process is fully automated using **GitHub Actions**. It employs a secure, pull-based deployment model:

1. On push to the `main` branch, GitHub Actions builds the Hugo site.
2. The generated static files (`site.zip`) are pushed to a private Amazon S3 artifact bucket.
3. GitHub Actions triggers an AWS Systems Manager (SSM) `SendCommand`.
4. The SSM Agent on the EC2 instance pulls the artifact from S3 via the Egress-Only IGW and safely updates the Nginx web directory.

## ✨ Project Features

* **Static Site Generator:** Built with [Hugo](https://gohugo.io/) using a customized version of the `Terminal` theme.
* **Internationalization (i18n):** Full bilingual support (English and Ukrainian) with dynamic URL routing and localized content.
* **Custom Interactive Visualizations:** Features vanilla HTML/JS interactive network flow animations demonstrating both the CI/CD Control Plane and the User Data Plane directly in the documentation.
* **Responsive UI:** Custom CSS flexbox implementations for mobile-friendly navigation.

## 🛠️ Tech Stack

* **Cloud:** AWS (EC2, VPC, S3, ALB, SSM, IAM)
* **IaC & Automation:** Terraform, GitHub Actions
* **Web & Network:** Nginx, Cloudflare, TCP/IP, IPv6
* **Frontend:** Hugo (Go Templating), HTML, CSS, Vanilla JS
* **OS & Scripting:** Linux (Amazon Linux 2023 / RHEL-based), Bash

## 💻 Local Development

To run this project locally, ensure you have [Hugo Extended](https://gohugo.io/installation/) installed.

1. Clone the repository:
   ```bash
   git clone <your-repository-url>
   cd <your-repository-directory>
   ```
2. Start the Hugo development server:
   ```bash
   hugo server -D
   ```
4. Open your browser and navigate to `http://localhost:1313`.

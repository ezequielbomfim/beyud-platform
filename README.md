Conteúdo recomendado para o README.md:

# BEYUD Platform

BEYUD Platform is a public production-style platform built to demonstrate modern Cloud, DevOps, Kubernetes and Platform Engineering practices on AWS.

The project is designed, implemented and operated end-to-end using infrastructure as code, containerization, Kubernetes, GitOps, observability and cloud-native architecture patterns.

## Objective

The goal of this project is to build a production-style platform on AWS with:

- AWS networking and infrastructure
- Terraform
- Docker
- Kubernetes with RKE2
- Rancher for cluster management
- GitHub Actions for CI
- Argo CD for GitOps-based delivery
- Amazon ECR for container images
- Amazon RDS PostgreSQL
- Route 53, ACM and Public ALB
- Prometheus, Grafana and Loki for observability
- Technical documentation, runbooks and architecture decisions

## Architecture

The platform uses a segmented AWS architecture:

- Public subnets for the internet-facing Application Load Balancer and NAT Gateway
- Private application subnets for RKE2 Kubernetes nodes
- Private data subnets for Amazon RDS PostgreSQL
- Private management subnet for Rancher Server
- Route 53 for DNS
- ACM for TLS certificates
- Amazon ECR for Docker images

![BEYUD Platform AWS Architecture](docs/architecture/beyud-platform-aws-architecture.png)

## Application Components

The application is composed of:

- `beyud-web`: public web frontend
- `beyud-api`: backend API
- `beyud-worker`: background worker
- `beyud-db`: PostgreSQL database

## Repository Structure

```text
apps/
  web/
  api/
  worker/

infra/
  terraform/

k8s/
  base/
  overlays/
  argocd/

docs/
  architecture/
  decisions/
  runbooks/
  evidences/
  linkedin/

.github/
  workflows/
Main Stack
Area	Technology
Cloud	AWS
Infrastructure as Code	Terraform
Containers	Docker
Kubernetes	RKE2
Cluster Management	Rancher
CI	GitHub Actions
CD / GitOps	Argo CD
Registry	Amazon ECR
Database	Amazon RDS PostgreSQL
DNS	Route 53
HTTPS	ACM + ALB
Metrics	Prometheus
Dashboards	Grafana
Logs	Loki + Promtail
Environment

The main environment is called prod-style.

This name is intentionally used because the project follows production-oriented practices, but it is not a real customer production environment.

Documentation

Architecture documentation is available in:

docs/architecture/overview.md
docs/architecture/aws-network.md
docs/architecture/kubernetes.md
docs/architecture/cicd-gitops.md
docs/architecture/observability.md

Architectural decisions are documented in:

docs/decisions/
Project Status

Current phase:

Etapa 0 — Architecture and Vision

Next phases:

Etapa 1 — Local application
Etapa 2 — Containerization
Etapa 3 — Local integrated environment with Docker Compose
Etapa 4 — Terraform AWS foundation
Etapa 5 — Compute and operational base
Etapa 6 — Kubernetes cluster
Etapa 7 — Application deployment
Etapa 8 — Observability
Etapa 9 — CI/CD and GitOps
Etapa 10 — Operational evidence
Etapa 11 — Professional positioning
Professional Positioning

This project is intended to demonstrate practical experience with cloud infrastructure, Kubernetes operations, GitOps, observability, automation and platform engineering.

It is not just a lab. It is a public production-style platform designed, implemented and documented end-to-end.


---

# 5. `docs/architecture/overview.md`

```md
# BEYUD Platform — Architecture Overview

## Summary

BEYUD Platform is a public production-style platform built on AWS to demonstrate modern Cloud, DevOps, Kubernetes and Platform Engineering practices.

The platform includes a real application composed of a web frontend, backend API, background worker and PostgreSQL database.

## High-Level Architecture

The architecture is based on:

- AWS VPC with public and private subnets
- Public Application Load Balancer
- Route 53 DNS
- ACM TLS certificate
- RKE2 Kubernetes cluster on private EC2 nodes
- Rancher Server in a private management subnet
- Amazon RDS PostgreSQL in private data subnets
- Amazon ECR for container images
- GitHub Actions for CI
- Argo CD for GitOps-based deployment
- Prometheus, Grafana and Loki for observability

## Main Traffic Flow

```text
Internet
  -> Route 53
  -> Public ALB HTTPS
  -> Ingress Controller
  -> beyud-web / beyud-api
  -> RDS PostgreSQL
Application Flow
User accesses the website
  -> Frontend loads
  -> User submits contact form
  -> API stores contact request in PostgreSQL
  -> Worker processes pending contacts
  -> Logs and metrics are collected
Management Flow
Rancher Server
  -> manages
RKE2 Kubernetes Cluster
Observability Flow
Pods and nodes
  -> Prometheus
  -> Grafana

Container logs
  -> Promtail
  -> Loki
  -> Grafana

---

# 6. `docs/architecture/aws-network.md`

```md
# AWS Network Architecture

## Region

The initial AWS region is:

```text
us-east-1
VPC
Name: beyud-prod-style-vpc
CIDR: 10.60.0.0/16
Subnets
Layer	Subnet	CIDR	AZ	Purpose
Public / Edge	Public Subnet A	10.60.0.0/24	us-east-1a	ALB, NAT Gateway
Public / Edge	Public Subnet B	10.60.1.0/24	us-east-1b	ALB
Application	Private App Subnet A	10.60.10.0/24	us-east-1a	RKE2 Node 01 and 03
Application	Private App Subnet B	10.60.11.0/24	us-east-1b	RKE2 Node 02
Data	Private Data Subnet A	10.60.20.0/24	us-east-1a	RDS DB Subnet Group
Data	Private Data Subnet B	10.60.21.0/24	us-east-1b	RDS DB Subnet Group
Management	Private Mgmt Subnet A	10.60.30.0/24	us-east-1a	Rancher Server
Public Entry Point

The only public application entry point is the internet-facing Application Load Balancer.

Internet
  -> Route 53
  -> Public ALB HTTPS
  -> Ingress Controller
Private Components

The following components run in private subnets:

RKE2 Kubernetes nodes
Rancher Server
RDS PostgreSQL
NAT Gateway

A single NAT Gateway is initially deployed in Public Subnet A.

It provides outbound internet access for private resources.

Examples:

OS updates
package downloads
container image pulls
Internet Gateway

The Internet Gateway is attached to the VPC and enables internet access for public resources such as the ALB and NAT Gateway.

Security Direction

The architecture avoids exposing EC2 instances and databases directly to the internet.

Public access is centralized through the ALB.


---

# 7. `docs/architecture/kubernetes.md`

```md
# Kubernetes Architecture

## Kubernetes Distribution

The platform uses RKE2 as the Kubernetes distribution.

## Cluster Nodes

The cluster runs on three private EC2 nodes:

```text
EC2 - RKE2 Node 01
EC2 - RKE2 Node 02
EC2 - RKE2 Node 03
Node Placement
Node	Subnet	AZ
RKE2 Node 01	Private App Subnet A	us-east-1a
RKE2 Node 02	Private App Subnet B	us-east-1b
RKE2 Node 03	Private App Subnet A	us-east-1a
Cluster Workloads

The cluster will run:

Ingress Controller
beyud-web
beyud-api
beyud-worker
Argo CD
Prometheus
Grafana
Loki
Promtail
Ingress

The Ingress Controller receives traffic from the AWS Public ALB and routes requests to Kubernetes services.

Public ALB HTTPS
  -> Ingress Controller
  -> beyud-web / beyud-api
Namespaces

Planned namespaces:

Namespace	Purpose
beyud-platform	Application workloads
beyud-gitops	Argo CD
beyud-observability	Prometheus, Grafana, Loki
beyud-ingress	Ingress Controller
Rancher

Rancher is used to manage the RKE2 cluster.

Rancher Server
  -> manages
RKE2 Kubernetes Cluster

Rancher runs in a private management subnet.


---

# 8. `docs/architecture/cicd-gitops.md`

```md
# CI/CD and GitOps Architecture

## Overview

The platform separates CI and CD responsibilities.

## CI — GitHub Actions

GitHub Actions is responsible for:

- building the application
- running tests
- building Docker images
- pushing images to Amazon ECR

## CD — Argo CD

Argo CD is responsible for:

- monitoring Kubernetes manifests in Git
- detecting drift
- synchronizing the desired state to the cluster
- supporting rollout and rollback workflows

## Container Registry

Amazon ECR stores Docker images for:

- beyud-web
- beyud-api
- beyud-worker

## Deployment Flow

```text
Developer
  -> Git commit
  -> GitHub Repository
  -> GitHub Actions
  -> Docker build
  -> Push image to Amazon ECR
  -> Update Kubernetes manifest image tag
  -> Argo CD sync
  -> RKE2 Kubernetes Cluster
Image Tag Strategy

The preferred image tag strategy is based on the Git commit SHA.

Example:

beyud-api:7f3a9c2

This improves traceability between code, image and deployment.


---

# 9. `docs/architecture/observability.md`

```md
# Observability Architecture

## Overview

The platform includes observability from the beginning to support operations, troubleshooting and evidence collection.

## Metrics

Prometheus is responsible for metrics collection.

Grafana is responsible for dashboards and visualization.

Metrics may include:

- node CPU and memory
- pod CPU and memory
- pod restarts
- deployment replicas
- API response time
- HTTP status codes
- application health checks

## Logs

Loki is responsible for log storage.

Promtail is responsible for collecting container logs and sending them to Loki.

```text
Container stdout logs
  -> Promtail
  -> Loki
  -> Grafana
Dashboards

Grafana will be used to visualize:

Kubernetes cluster health
application health
pod and node metrics
API metrics
logs from application containers
Application Logs

The applications should write logs to stdout/stderr so Kubernetes and Promtail can collect them.

Expected log sources:

beyud-api
beyud-worker
ingress controller
Kubernetes system components
Goal

The goal is to troubleshoot the platform using evidence, not guesswork.


---

# 10. `.gitignore` inicial

```gitignore
# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/

# Node
node_modules/
dist/
build/
.env

# .NET
bin/
obj/
*.user
*.suo

# Terraform
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
crash.log
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Kubernetes secrets
*-secret.yaml
secrets.yaml

# Logs
*.log
# 0002 — Use AWS as the main cloud provider

## Status

Accepted

## Context

The project aims to demonstrate practical skills in cloud infrastructure, Kubernetes, automation, observability and platform operations.

AWS was selected because it is widely used in the market and provides all required services for this architecture, including VPC, EC2, ALB, Route 53, ACM, ECR, RDS, IAM and Systems Manager.

## Decision

Use AWS as the main cloud provider for the BEYUD Platform.

The initial region will be `us-east-1`.

## Alternatives considered

- Oracle Cloud Infrastructure
- Microsoft Azure
- Local-only Kubernetes environment
- Managed Kubernetes with EKS

## Consequences

AWS provides strong market relevance and a broad set of cloud services.

Using EC2-based Kubernetes instead of EKS increases operational learning, especially around nodes, networking, Rancher and RKE2 management.

The main trade-off is that this approach requires more manual architecture and operational responsibility than a fully managed Kubernetes service.

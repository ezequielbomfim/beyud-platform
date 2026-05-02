# 0009 — Use private subnets for core components

## Status

Accepted

## Context

The platform contains components that should not be directly exposed to the internet, including Kubernetes nodes, Rancher and the database.

The only public entry point should be the Application Load Balancer.

## Decision

Use private subnets for:

- RKE2 Kubernetes nodes
- Rancher Server
- RDS PostgreSQL

Use public subnets only for:

- Public ALB
- NAT Gateway

## Alternatives considered

- Public EC2 instances with security group restrictions
- Public Rancher access
- Database with public accessibility enabled

## Consequences

This improves the security posture of the platform by reducing direct exposure.

Administrative access should use AWS Systems Manager Session Manager or controlled access mechanisms.

The trade-off is that private resources require NAT Gateway or VPC endpoints for outbound access.

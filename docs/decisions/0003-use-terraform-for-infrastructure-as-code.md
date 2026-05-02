# 0003 — Use Terraform for infrastructure as code

## Status

Accepted

## Context

The BEYUD Platform requires multiple AWS resources, including VPC, subnets, route tables, NAT Gateway, security groups, EC2 instances, RDS, ECR, IAM, ALB, ACM and Route 53 records.

Creating these resources manually would make the environment harder to reproduce, review and document.

## Decision

Use Terraform as the infrastructure as code tool for provisioning AWS resources.

## Alternatives considered

- AWS CloudFormation
- AWS CDK
- Manual provisioning through the AWS Console

## Consequences

Terraform makes the infrastructure reproducible, versioned and easier to explain.

It also aligns with DevOps and Cloud Engineer job requirements.

The trade-off is the need to manage remote state, modules, variables and environment separation carefully.

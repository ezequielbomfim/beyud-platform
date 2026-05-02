# 0006 — Use GitHub Actions and Argo CD

## Status

Accepted

## Context

The platform requires automated build, container image publishing and Kubernetes deployment.

The project also aims to demonstrate modern CI/CD and GitOps practices.

## Decision

Use GitHub Actions for CI and Argo CD for CD/GitOps.

GitHub Actions will handle:

- build
- tests
- Docker image build
- push to Amazon ECR

Argo CD will handle:

- Kubernetes deployment
- GitOps synchronization
- rollout visibility
- rollback support

## Alternatives considered

- Azure DevOps Pipelines
- GitLab CI/CD
- Jenkins
- Manual kubectl apply

## Consequences

This separation makes the pipeline architecture clear:

- GitHub Actions handles CI.
- Argo CD handles GitOps-based CD.

It also increases market relevance because GitHub Actions and Argo CD are commonly used in modern Kubernetes environments.

The trade-off is the need to manage repository structure, image tags and manifest updates carefully.

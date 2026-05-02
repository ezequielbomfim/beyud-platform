# 0001 — Use monorepo for BEYUD Platform

## Status

Accepted

## Context

The BEYUD Platform includes multiple parts: web application, API, worker, infrastructure as code, Kubernetes manifests, GitOps configuration and documentation.

Managing these components in separate repositories would add complexity for a project that is intended to demonstrate an end-to-end platform architecture.

## Decision

Use a single monorepo called `beyud-platform`.

The repository will contain:

- `apps/web`
- `apps/api`
- `apps/worker`
- `infra/terraform`
- `k8s`
- `docs`
- `.github/workflows`

## Alternatives considered

- Multiple repositories for each application and infrastructure component.
- A single repository only for application code and another for infrastructure.

## Consequences

This approach centralizes the platform, makes documentation easier and helps present the project as an end-to-end production-style platform.

The main trade-off is that the repository can grow over time, so folder structure and naming standards must remain clear.

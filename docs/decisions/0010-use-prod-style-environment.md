# 0010 — Use prod-style environment naming

## Status

Accepted

## Context

The BEYUD Platform is designed with production-like characteristics, including private subnets, load balancing, Kubernetes, GitOps, observability, database separation and infrastructure as code.

However, it is not a real customer production environment.

## Decision

Use the environment name `prod-style`.

The project will be described as a production-style platform, not as a real production customer environment.

## Alternatives considered

- Naming the environment `production`
- Naming the environment `lab`
- Naming the environment `dev`

## Consequences

The `prod-style` naming keeps the project honest and professional.

It communicates that the architecture follows production-oriented practices without claiming that it is a real commercial production workload.

This also helps position the project correctly in interviews, LinkedIn and documentation.

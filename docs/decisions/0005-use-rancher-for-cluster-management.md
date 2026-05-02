# 0005 — Use Rancher for cluster management

## Status

Accepted

## Context

The project includes a Kubernetes cluster based on RKE2. Managing the cluster only by command line is possible, but Rancher provides a visual and centralized management layer.

The project also aims to demonstrate knowledge of platform operations and cluster administration.

## Decision

Use Rancher as the Kubernetes management platform.

Rancher will run on a private EC2 instance in the management subnet.

## Alternatives considered

- kubectl-only management
- Lens
- Kubernetes Dashboard
- Managed control plane through EKS

## Consequences

Rancher improves cluster visibility and helps demonstrate a production-style management approach.

Keeping Rancher in a private management subnet reduces exposure.

The trade-off is the need to operate and secure an additional management component.

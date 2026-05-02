# 0004 — Use RKE2 for Kubernetes

## Status

Accepted

## Context

The project requires a Kubernetes environment with real nodes to demonstrate cluster operations, networking, ingress, troubleshooting, observability and GitOps.

The goal is not only to deploy applications, but also to understand and operate the Kubernetes platform.

## Decision

Use RKE2 as the Kubernetes distribution for the BEYUD Platform.

The cluster will initially run on three private EC2 nodes.

## Alternatives considered

- Amazon EKS
- k3s
- kubeadm
- Kind
- Minikube

## Consequences

RKE2 provides a production-oriented Kubernetes distribution and works well with Rancher.

Running it on EC2 private nodes provides strong learning value around cluster installation, node management, networking and operations.

The trade-off is that this model requires more operational responsibility than a managed Kubernetes service like EKS.

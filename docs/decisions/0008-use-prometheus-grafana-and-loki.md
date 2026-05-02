# 0008 — Use Prometheus, Grafana and Loki for observability

## Status

Accepted

## Context

The platform should not only deploy applications, but also provide operational visibility.

The project requires metrics, logs and dashboards to support troubleshooting and demonstrate observability practices.

## Decision

Use the following observability stack:

- Prometheus for metrics collection
- Grafana for dashboards
- Loki for log storage
- Promtail for log collection

## Alternatives considered

- CloudWatch only
- ELK Stack
- Datadog
- New Relic

## Consequences

This stack is common in Kubernetes environments and provides a strong learning path for monitoring and troubleshooting.

Grafana centralizes both metrics and logs.

The trade-off is that the observability stack also consumes cluster resources and must be installed, configured and maintained.

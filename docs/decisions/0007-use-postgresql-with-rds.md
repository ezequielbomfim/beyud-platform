# 0007 — Use PostgreSQL with Amazon RDS

## Status

Accepted

## Context

The BEYUD Platform requires a relational database to store contact requests and support application status features.

The database should not be exposed publicly and should be managed separately from the Kubernetes workloads.

## Decision

Use PostgreSQL as the database engine and Amazon RDS as the managed database service.

The RDS instance will be deployed in private data subnets using a DB Subnet Group.

## Alternatives considered

- PostgreSQL running inside Kubernetes
- MySQL
- SQL Server
- DynamoDB

## Consequences

Using RDS reduces operational responsibility for the database and keeps the data layer separate from the application layer.

PostgreSQL is widely used, simple to run locally and easy to integrate with .NET applications.

The initial deployment may be Single-AZ for cost control, with a future path to Multi-AZ.

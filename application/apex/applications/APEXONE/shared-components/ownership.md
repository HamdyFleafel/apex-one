# Shared Components Ownership

| Component | Owner | Rule |
|---|---|---|
| Users LOV | Identity | Derived from Identity APIs/views |
| Roles LOV | Security | Derived from Security APIs/views |
| Status LOV | Platform/Application contract | One canonical status definition |
| Authentication Scheme | Identity | One application authentication scheme |
| Authorization Schemes | Security | Reusable RBAC adapters |
| Main Menu | Application | Navigation only; no business logic |
| Administration Menu | Application | Navigation only; permission-gated |
| Operations Menu | Application | Navigation only; permission-gated |

Shared components are application-wide adapters/configuration. They are not a second location for database business rules.

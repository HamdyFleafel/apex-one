# APEXONE Architecture Baseline v1.0

**Status:** Approved  
**Baseline:** v1.0  
**Scope:** Repository and runtime architecture  
**Decision:** This document is the architectural reference for implementation.

## 1. Architectural Model

```text
                         ┌───────────────────────────┐
                         │       APEX / Clients       │
                         └─────────────┬─────────────┘
                                       │
                         ┌─────────────▼─────────────┐
                         │       ORDS / REST         │
                         └─────────────┬─────────────┘
                                       │
              ┌────────────────────────▼────────────────────────┐
              │              Oracle AI Database 26ai             │
              │                                                  │
              │  ┌────────────────────────────────────────────┐  │
              │  │ Database Modules                           │  │
              │  │ Core | Identity | Security | Config        │  │
              │  │ Notification | Workflow                    │  │
              │  └──────────────────────┬─────────────────────┘  │
              │                         │                        │
              │  ┌──────────────────────▼─────────────────────┐  │
              │  │ Database Platform Framework                 │  │
              │  │ Context | Errors | Logging | Session       │  │
              │  │ Validation | Utilities | Constants         │  │
              │  └──────────────────────┬─────────────────────┘  │
              │                         │                        │
              │  ┌──────────────────────▼─────────────────────┐  │
              │  │ Infrastructure / Storage                   │  │
              │  │ Tablespaces | DB roles | platform objects │  │
              │  └────────────────────────────────────────────┘  │
              └──────────────────────────────────────────────────┘

        Delivery / Governance / Operations surround the runtime
        and are not application business-logic layers.
```

## 2. Layer Rules

### Application Layer
Owns APEX applications, ORDS configuration, REST modules and static assets.

### Database Platform Layer
Owns reusable technical capabilities required by multiple modules. It must not own business-specific workflows.

### Database Module Layer
Owns one business capability and all of its database objects: tables, constraints, indexes, sequences, packages, seed and module installation.

### Delivery Layer
Owns deterministic installation, migrations, seed execution, build orchestration and verification. Delivery scripts orchestrate; they do not duplicate module source.

### Operations Layer
Owns runtime support activities: backup, recovery, monitoring, diagnostics, maintenance and health checks.

### Governance Layer
Owns standards, architecture decisions, data dictionary, catalogs and engineering policies.

## 3. Dependency Direction

```text
Application
    ↓
ORDS / REST
    ↓
Database Modules
    ↓
Database Platform
    ↓
Oracle Database / Infrastructure

Delivery → installs/verifies the layers
Operations → observes/maintains the runtime
Governance → constrains and documents all layers
```

A lower layer must not depend on a higher layer.

## 4. Module Ownership

| Module | Responsibility |
|---|---|
| Core | platform data primitives, schema versioning, file metadata and core errors |
| Identity | users, roles, permissions, sessions and authentication identity |
| Security | authorization policy, audit and security enforcement |
| Configuration | application/platform configuration |
| Notification | notification templates and notification delivery state |
| Workflow | workflow definitions and tasks |

**Identity owns identity data. Security owns security enforcement and audit.** Cross-cutting session/security behavior must use explicit package APIs rather than duplicated tables or packages.

## 5. Source-of-Truth Rule

There is exactly one canonical source for each responsibility.

- Module implementation lives only under `database/modules/<module>/`.
- Shared technical database implementation lives only under `database/platform/`.
- Application implementation lives only under `application/`.
- Database deployment orchestration lives only under `database/deployment/`.
- Database operations live only under `database/operations/`.
- Architecture and project governance documentation lives only under `docs/`.
- Current project state lives only under `project-status/`.
- Historical/generated artifacts are not part of the source tree.

No second directory may be introduced for the same responsibility without an ADR.

## 6. Installation Contract

The canonical entry point is:

```text
database/deployment/install/install.sql
```

It executes in dependency order:

```text
Platform Framework
      ↓
Core
      ↓
Identity
      ↓
Security
      ↓
Configuration
      ↓
Notification
      ↓
Workflow
      ↓
Seed / Verification / Health
```

## 7. Non-Goals

This baseline does not require microservices, database-per-module, distributed transactions or unnecessary infrastructure complexity.

The architecture is intentionally modular while remaining a coherent Oracle database platform.

## 8. Change Control

Any change to these rules requires an Architecture Decision Record (ADR). The baseline is not to be repeatedly redesigned during normal implementation.


## 9. Repository Invariants

The following rules are mandatory:

1. One responsibility has one owner.
2. One artifact has one canonical location.
3. `docs/architecture/` is the only architecture-documentation root.
4. `tests/` is the only repository-level test root.
5. `database/modules/` is the only module implementation root.
6. `database/platform/` is the only shared technical database implementation root.
7. Backups and generated artifacts never sit beside source files.
8. `core`, `common`, `shared`, `misc` and similar catch-all directories require an ADR before creation.
9. Moving an artifact requires updating all references in the same change.
10. Architectural exceptions require an ADR; ordinary development must not redefine the structure.

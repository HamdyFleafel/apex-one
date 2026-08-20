# APEXONE APEX Application Architecture

**Status:** Approved for Foundation
**Version:** 1.0

## 1. Single Source of Truth

The canonical APEX application implementation is:

`application/apex/applications/APEXONE/export/`

The root `application/export/` location is intentionally not used. There is exactly one application export location.

## 2. Application Boundary

APEX is the presentation/composition layer. Database modules remain the owners of persistent business capabilities and rules.

## 3. Security Boundary

- Authentication: Identity database contract.
- Authorization: Security database contract using RBAC.
- Persistent sessions: database contract.
- Audit persistence: Security contract.

APEX authorization schemes are adapters, not a second authorization system.

## 4. Page Ownership

| Range | Responsibility |
|---|---|
| 1 | Public authentication |
| 100-199 | Platform/dashboard |
| 200-299 | Identity |
| 300-499 | Security |
| 500-599 | Configuration |
| 600-699 | Audit/Security |
| 700-799 | Workflow |
| 800-899 | Notification |

Page IDs are architectural identifiers. New pages must remain inside their owning range unless an ADR approves an exception.

## 5. Shared Components

Shared components provide application-wide presentation and adapters. They must not become a duplicate business-logic layer.

## 6. Deployment

The APEX application is installed only from its authoritative export. `install.sql`, `uninstall.sql`, and `deploy.ps1` orchestrate lifecycle; they do not contain a second application implementation.

## 7. Current State

The application ID is reserved and the authoritative APEX export has not yet been generated. This is intentional. No fake export is stored in source control.

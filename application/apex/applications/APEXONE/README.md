# APEXONE APEX Application

This directory is the **single source of truth** for the APEXONE APEX application.

## Ownership

- `export/` — canonical APEX export artifact(s) once an application ID is assigned.
- `install/` — application installation orchestration only.
- `uninstall/` — application removal orchestration only.
- `deploy.ps1` — environment-aware deployment entry point only.
- `metadata/` — durable application metadata and contracts; never a second implementation.
- `architecture/` — application-layer architecture decisions and maps.
- `pages/` — page ownership map; page implementation remains in the APEX export.
- `shared-components/` — shared-component ownership map; implementation remains in the APEX export.
- `security/` — authentication/authorization contract; implementation remains in the APEX export and database APIs.

## Source-of-truth rule

The APEX export is the only canonical implementation of the APEX application. Metadata files describe and validate it; they do not duplicate it.

The application must consume database capabilities through published package/API contracts. It must not reproduce database business logic in page processes when a database API exists.

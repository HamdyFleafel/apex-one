# APEXONE Enterprise Platform

APEXONE is an enterprise application platform built on Oracle AI Database 26ai, Oracle APEX and ORDS.

## Architecture

The repository follows a single-owner, single-source architecture:

1. **Application** — APEX, ORDS, REST and static assets.
2. **Database Platform** — shared technical database capabilities.
3. **Database Modules** — functional capabilities with explicit ownership.
4. **Database Delivery** — deployment, migration, seed, build and verification.
5. **Database Operations** — backup, recovery, monitoring, diagnostics and maintenance.
6. **Governance & Documentation** — authoritative project knowledge under `docs/`.
7. **Project Status** — current state only under `project-status/`.

## Source of truth

Every responsibility has one canonical owner and every artifact has one canonical location.

See [`docs/architecture/ARCHITECTURE_BASELINE_v1.0.md`](docs/architecture/ARCHITECTURE_BASELINE_v1.0.md).
See [`docs/architecture/REPOSITORY_STRUCTURE.md`](docs/architecture/REPOSITORY_STRUCTURE.md).

## Structure validation

Run `scripts/check_repository_structure.ps1` before structural changes and releases.


## Architecture

The binding architecture baseline is `docs/architecture/ARCHITECTURE_BASELINE_v1.0.md`.
Responsibility ownership and anti-duplication rules are defined in `docs/architecture/OWNERSHIP_MATRIX.md`.

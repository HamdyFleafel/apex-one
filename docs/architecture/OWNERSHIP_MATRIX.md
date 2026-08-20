# APEXONE Ownership Matrix

**Status:** Approved
**Authority:** `ARCHITECTURE_BASELINE_v1.0.md`

| Responsibility | Canonical owner | Must not be duplicated in |
|---|---|---|
| APEX application | `application/` | `database/`, `docs/` source trees |
| Shared database framework | `database/platform/` | `database/modules/`, deployment scripts |
| Business database module | `database/modules/<module>/` | `database/platform/`, deployment scripts |
| Database installation/lifecycle orchestration | `database/deployment/` | module source directories |
| Database verification | `database/verification/` | module source directories |
| Runtime database operations | `database/operations/` | deployment/build directories |
| Database standards | `database/governance/standards/` | `docs/standards/` |
| Architecture | `docs/architecture/` | `database/`, `project-status/` |
| Engineering standards | `docs/standards/` | implementation directories |
| Architecture decisions | `docs/adr/` | implementation/governance folders |
| Decision register | `docs/DECISION_LOG.md` | second decision registers |
| Current project state | `project-status/` | `docs/` status copies |
| Repository-level tests | `tests/` | root `test/` |
| Historical/generated artifacts | external archive | repository source tree |

## Rules

1. Every responsibility has exactly one canonical owner.
2. A deployment script may call source; it may not copy source.
3. Documentation may describe implementation; it may not become a second implementation.
4. A new owner or exception requires an ADR before the directory is created.

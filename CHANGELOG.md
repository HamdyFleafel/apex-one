# Changelog

## 1.0.0-alpha.9

- Synchronized project version metadata and current-state documents.
- Established the lifecycle module installer as the single canonical module orchestration owner.
- Converted legacy build orchestration paths to delegation wrappers to remove duplicate module installation paths.

## 1.0.0-alpha.7 — 2026-08-16

### Fixed
- Removed duplicate Core `PKG_ERROR`; `PKG_ERRORS` is the single canonical error framework owner.
- Removed the obsolete Core installation references to `PKG_ERROR`.
- Synchronized project version metadata to `1.0.0-alpha.7`.

# Changelog

## 1.0.0-alpha.5 — 2026-08-16

- Removed historical backup copies and empty legacy placeholders from the source tree.
- Moved file-storage architecture into the canonical architecture documentation root.
- Established a single ownership matrix for repository responsibilities.
- Removed duplicate project-decision and repository-baseline documents.
- Reset project status to the approved architecture baseline and current execution focus.


## 1.0.0-alpha.4 — 2026-08-16

- Enforced the canonical single-owner repository architecture.
- Consolidated architecture documentation under `docs/architecture/`.
- Consolidated project governance documents under `docs/`.
- Removed duplicate Identity/Security ownership of `APP_SESSIONS` and `APP_LOGIN_ATTEMPTS`.
- Removed duplicate repository structure snapshots and obsolete source-tree backup copies.

## 1.0.0-alpha.3 — 2026-08-15

- Corrected release-integrity gate and canonical deployment lifecycle.
- Corrected Identity session package body to match its specification.
- Corrected installation verification syntax and added post-install health validation.
- Preserved rollback as unsupported until complete rollback coverage is implemented and tested.

## 1.0 Architecture Baseline — 2026-08-15

- Applied Architecture Baseline v1.0 and canonical layer ownership.

## 1.0.0-alpha.2 — 2026-08-01

- Initial enterprise repository structure and database/application scaffolding.

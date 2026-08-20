# Database Foundation Review — v1.0.0-alpha.7

**Status:** Corrective review applied; canonical error ownership enforced.

## Findings fixed

1. `APP_SESSIONS` and `APP_LOGIN_ATTEMPTS` remain Identity-owned. Empty duplicate Platform session scaffolding was removed.
2. `PKG_SECURITY_HASH` remains in `database/platform/framework/security/` as a reusable technical security primitive.
3. `PKG_AUTHENTICATION` remains in `database/modules/security/` because its implementation depends on security policy, audit and lockout enforcement.
4. Authentication lockout test remains with its owning module under `database/modules/security/tests/`.
5. Platform framework installation creates `PKG_SECURITY_HASH` before module installation.
6. Security installation compiles its prerequisites before `PKG_AUTHENTICATION`.
7. Release integrity paths match ownership.
8. `PKG_SECURITY_LOCKOUT` is implemented in Security and installed before authentication.
9. The lockout contract is deterministic: five failed attempts trigger a fifteen-minute lock and reset is handled by successful authentication.
10. The duplicate Core `PKG_ERROR` API was removed; `PKG_ERRORS` is the single canonical error framework owner.
11. Core installation no longer references the removed `PKG_ERROR` package.

## Canonical dependency contract

```text
Platform Framework
    ├── PKG_ERRORS
    └── PKG_SECURITY_HASH
            ↓
Core
    ↓
Identity
    ├── identity data
    ├── APP_SESSIONS
    ├── PKG_SESSION
    └── PKG_IDENTITY
            ↓
Security
    ├── PKG_SECURITY
    ├── PKG_SECURITY_POLICY
    ├── PKG_AUDIT
    ├── PKG_AUTHENTICATION
    ├── PKG_SECURITY_LOCKOUT
    └── PKG_AUTHORIZATION
```

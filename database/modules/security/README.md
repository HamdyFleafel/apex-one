# Security Module

## Ownership Boundary

Security owns authentication enforcement, authorization policy, audit, password policy, lockout and security-specific history.

Identity owns identity data and session state, including:
- `APP_USERS`
- `APP_ROLES`
- `APP_PERMISSIONS`
- `APP_ROLE_PERMISSIONS`
- `APP_USER_ROLES`
- `APP_SESSIONS`
- `APP_LOGIN_ATTEMPTS`

Platform owns reusable technical security primitives such as password hashing.

Security consumes Identity objects and Platform security APIs. It must not recreate Identity-owned tables.

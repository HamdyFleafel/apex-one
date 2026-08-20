# Create User Integration Contract v1

## 1. Purpose

This document defines the first Core Integration contract for user creation in APEXONE.

The contract establishes the boundary between a future external integration adapter (REST/ORDS/APEX) and the existing Identity service API.

The integration layer must delegate user creation to `PKG_IDENTITY.CREATE_USER` and must not duplicate Identity business logic.

## 2. Contract Status

- **Version:** v1
- **Status:** Baseline for Phase 10
- **Scope:** User creation only
- **Business Logic:** Owned by `PKG_IDENTITY`
- **External Adapter:** Deferred to a later Phase 10 slice

## 3. Integration Flow

```text
External Integration
        |
        v
Future REST / ORDS Adapter
        |
        v
PKG_IDENTITY.CREATE_USER
        |
        +--> PKG_SECURITY_HASH
        |
        +--> APP_USERS
        |
        +--> APP_PASSWORD_HISTORY
        |
        +--> PKG_ERRORS
        |
        v
     USER_ID
```
## 4. Input Contract

| Field      | Type     | Required |
| ---------- | -------- | -------: |
| `username` | VARCHAR2 |      Yes |
| `email`    | VARCHAR2 |      Yes |
| `password` | VARCHAR2 |      Yes |

## 5. Output Contract

| Field     | Type   | Meaning                              |
| --------- | ------ | ------------------------------------ |
| `user_id` | NUMBER | Identifier of the newly created user |

## 6. Business Logic Ownership

User-management business rules remain exclusively owned by `PKG_IDENTITY`.

The integration layer must not reimplement username validation, email validation, password hashing, user creation, or password-history management.

## 7. Persistence Boundary

The current Identity implementation persists through:

* `APP_USERS`
* `APP_PASSWORD_HISTORY`

These are implementation details and are not part of the external integration contract.

## 8. Error Contract

The integration boundary preserves the error semantics produced by the Identity service.

The current implementation uses:

* `PKG_ERRORS.RAISE_IDENTITY_ERROR`
* `PKG_ERRORS.RAISE_ERROR`

No new external error-code taxonomy is introduced by v1.

## 9. Transaction Contract

Transaction ownership is not defined by this contract.

This contract does not claim commit or rollback ownership.

## 10. Security Boundary

The integration layer must treat `password` as sensitive input.

The password must not be persisted, logged, or exposed in diagnostics by the integration layer.

Password hashing remains the responsibility of the existing security implementation.

## 11. Scope Exclusions

The following are outside v1:

* session management
* role management
* authorization
* audit orchestration
* centralized logging
* JSON framework implementation
* application context implementation
* REST/ORDS implementation
* APEX page implementation

## 12. Future Adapter

The future adapter follows:

```text
Request
  |
  v
Validate integration-level contract
  |
  v
PKG_IDENTITY.CREATE_USER
  |
  v
Receive USER_ID
  |
  v
Map result to external response
```



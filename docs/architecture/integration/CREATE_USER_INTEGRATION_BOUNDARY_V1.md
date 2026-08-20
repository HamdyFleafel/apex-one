
# Create User Integration Boundary Specification v1

## 1. Purpose

This document defines the integration boundary for user creation in APEXONE.

It specifies how an external integration request is translated into a call to the existing Identity service and how the resulting user identifier or error is translated back to the external boundary.

This specification does not define a REST, ORDS, or APEX implementation.

---

## 2. Boundary Flow

```text
External Request
      |
      v
Integration Boundary
      |
      v
PKG_IDENTITY.CREATE_USER
      |
      v
USER_ID
      |
      v
External Response
```

---

## 3. External Request Mapping

The external integration request contains the following fields:

| External Field | Identity Parameter | Required |
| -------------- | ------------------ | -------: |
| `username`     | `P_USERNAME`       |      Yes |
| `email`        | `P_EMAIL`          |      Yes |
| `password`     | `P_PASSWORD`       |      Yes |

The integration boundary performs a direct semantic mapping:

```text
request.username  -> P_USERNAME
request.email     -> P_EMAIL
request.password  -> P_PASSWORD
```

---

## 4. Identity Service Invocation

The integration boundary invokes:

`PKG_IDENTITY.CREATE_USER`

with the following parameters:

```text
PKG_IDENTITY.CREATE_USER(
    P_USERNAME => request.username,
    P_EMAIL    => request.email,
    P_PASSWORD => request.password
)
```

The function returns the newly created `USER_ID`.

The integration boundary must not directly insert into `APP_USERS` or `APP_PASSWORD_HISTORY`.

---

## 5. Success Mapping

When `PKG_IDENTITY.CREATE_USER` completes successfully, the returned identifier is mapped to the external response.

```text
PKG_IDENTITY.CREATE_USER
          |
          v
       USER_ID
          |
          v
External Response
```

The external response represents the newly created user's identifier as:

```text
user_id
```

---

## 6. Error Mapping

Errors raised by the Identity service are propagated to the integration boundary.

The integration boundary must not reimplement Identity validation or create alternative Identity error handling.

Current Identity error sources include:

* `PKG_ERRORS.RAISE_IDENTITY_ERROR`
* `PKG_ERRORS.RAISE_ERROR`

The external adapter may later translate these errors into its own transport-level representation, but that translation is outside this boundary specification.

---

## 7. Security Boundary

The `password` value is sensitive.

The integration boundary must:

* never persist the plaintext password;
* never write the plaintext password to logs;
* never include the plaintext password in diagnostics;
* pass the password only to the Identity service invocation.

Password hashing and password-history handling remain owned by the existing Identity/Security implementation.

---

## 8. Persistence Boundary

The integration boundary has no direct persistence responsibility.

Persistence remains behind `PKG_IDENTITY.CREATE_USER`.

```text
Integration Boundary
        |
        v
PKG_IDENTITY.CREATE_USER
        |
        +--> APP_USERS
        |
        +--> APP_PASSWORD_HISTORY
```

The integration layer must not depend on the internal persistence sequence.

---

## 9. Transaction Boundary

This specification does not assign transaction ownership to the integration boundary.

The boundary must not introduce an implicit commit or rollback contract.

Transaction behavior remains subject to the implementation layer that invokes the Identity service.

---

## 10. Responsibility Matrix

| Responsibility               | Owner                         |
| ---------------------------- | ----------------------------- |
| External request validation  | Integration Adapter           |
| Request-to-service mapping   | Integration Boundary          |
| Username validation          | `PKG_IDENTITY`                |
| Email validation             | `PKG_IDENTITY`                |
| Password hashing             | `PKG_SECURITY_HASH`           |
| User persistence             | `PKG_IDENTITY`                |
| Password history persistence | `PKG_IDENTITY`                |
| Identity error generation    | `PKG_ERRORS`                  |
| External transport mapping   | Future REST/ORDS/APEX Adapter |

---

## 11. Non-Goals

This specification does not define:

* REST endpoints;
* ORDS modules;
* HTTP status codes;
* JSON implementation;
* authentication;
* session creation;
* role assignment;
* authorization;
* audit implementation;
* centralized logging;
* APEX pages.

---

## 12. Architectural Rule

The integration boundary is an adapter boundary, not a second business-service layer.

The architectural rule is:

```text
External Request
      |
      v
Integration Boundary
      |
      v
PKG_IDENTITY.CREATE_USER
      |
      v
Existing Identity / Security / Persistence
```

Business logic must remain inside the existing service packages.

---

## 13. Version and Status

* **Version:** v1
* **Status:** Architecture Baseline
* **Scope:** Create User Integration Boundary
* **Phase:** Phase 10
* **Implementation:** Deferred to REST/ORDS/APEX adapter phase

---

## 14. Acceptance Criteria

The boundary specification is considered complete when:

1. The external `username` maps to `P_USERNAME`.
2. The external `email` maps to `P_EMAIL`.
3. The external `password` maps to `P_PASSWORD`.
4. User creation delegates exclusively to `PKG_IDENTITY.CREATE_USER`.
5. The resulting `USER_ID` maps to the external `user_id`.
6. The integration layer does not duplicate Identity business logic.
7. The integration layer does not directly access Identity persistence tables.
8. Plaintext passwords are not persisted or logged by the integration layer.
9. No REST/ORDS/APEX implementation is introduced by this specification.
10. Transaction ownership remains explicitly undefined at this boundary.

---


# REST / ORDS Adapter Specification v1

## 1. Purpose

This document defines the architecture specification for the future REST / ORDS adapter responsible for user creation in APEXONE.

The adapter exposes the external transport boundary and delegates user creation exclusively to the existing Identity service API.

This specification defines the transport contract only. It does not implement an ORDS module, REST handler, PL/SQL adapter, or APEX page.

---

## 2. Architectural Position

The REST / ORDS adapter is a transport adapter.

It must not become a second Identity business-service layer.

The architectural flow is:

HTTP Client
    |
    v
REST / ORDS Adapter
    |
    v
Integration Boundary
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
    |
    v
REST / ORDS Response

---
## 3. Endpoint Contract

The future adapter exposes a user-creation operation.

| Property | Value |
|---|---|
| Method | POST |
| Endpoint | /users |
| Purpose | Create a new user |
| Authentication | Defined by future security phase |
| Content-Type | application/json |
| Response-Type | application/json |

The exact ORDS module and privilege configuration are outside this specification.

---

## 4. Request JSON Contract

The request body contains:

| Field | Type | Required | Sensitive |
|---|---|---:|---:|
| username | string | Yes | No |
| email | string | Yes | No |
| password | string | Yes | Yes |

Example request:

{
  "username": "example_user",
  "email": "user@example.com",
  "password": "********"
}

The adapter maps these fields to the Integration Boundary:

request.username  -> P_USERNAME
request.email     -> P_EMAIL
request.password  -> P_PASSWORD

---

## 5. Identity Service Delegation

The adapter delegates user creation exclusively to:

PKG_IDENTITY.CREATE_USER

The adapter must not:

- insert directly into APP_USERS;
- insert directly into APP_PASSWORD_HISTORY;
- perform password hashing;
- duplicate username validation;
- duplicate email validation;
- implement Identity business rules.

---
## 6. Success Response Contract

A successful user creation returns:

{
  "user_id": 12345
}

The user_id value is the USER_ID returned by PKG_IDENTITY.CREATE_USER.

---

## 7. HTTP Success Status

| Condition | HTTP Status |
|---|---:|
| User created successfully | 201 Created |

The adapter must not expose internal database structures in the success response.

---
## 8. Error Response Contract

The adapter translates Identity errors into a transport-level JSON response.

The baseline response structure is:

{
  "error": {
    "code": "IDENTITY_ERROR",
    "message": "User creation failed"
  }
}

For Identity errors, the adapter must preserve the semantic error class without exposing internal PL/SQL implementation details or raw Oracle error text.

For duplicate username or duplicate email, the Identity service raises the Identity error class through:

PKG_ERRORS.RAISE_IDENTITY_ERROR

which maps to Oracle application error code -20001.

The REST / ORDS adapter may classify `-20001` as the established Identity semantic error class. It must not parse raw Oracle message text to infer the error class.

The external transport representation of this condition is 409 Conflict.

The exact external error-code taxonomy remains an adapter concern and may be refined in the future error transport policy.

---

## 9. HTTP Error Mapping

The baseline transport mapping is:

| Condition | Identity Source | HTTP Status |
|---|---|---:|
| Invalid transport request | Integration Adapter validation | 400 Bad Request |
| Authentication failure | Future security boundary | 401 Unauthorized |
| Authorization failure | Future security boundary | 403 Forbidden |
| Duplicate username | PKG_ERRORS.RAISE_IDENTITY_ERROR / -20001 | 409 Conflict |
| Duplicate email | PKG_ERRORS.RAISE_IDENTITY_ERROR / -20001 | 409 Conflict |
| Unexpected application failure | PKG_ERRORS.RAISE_ERROR / generic error | 500 Internal Server Error |

The adapter must not expose raw database error messages, SQL statements, stack traces, or internal persistence details.

The adapter must classify errors by their established semantic meaning and must not duplicate Identity business rules.

Authentication and authorization mappings are defined here as transport placeholders only; their implementation belongs to the future security phase.

---
## 10. Security Boundary

The password field is sensitive.

The adapter must:

- never log the plaintext password;
- never persist the plaintext password;
- never include the plaintext password in an error response;
- never include the plaintext password in diagnostics;
- pass the password only to the Identity service boundary.

Authentication and authorization are outside this v1 specification.

---
## 11. Transaction Boundary

The REST / ORDS adapter does not define transaction ownership.

It must not introduce an implicit commit or rollback contract.

Transaction behavior remains owned by the implementation layer invoking the Identity service.

---
## 12. Architectural Non-Goals

This specification does not implement:

- ORDS modules;
- ORDS privileges;
- REST handlers;
- PL/SQL adapter packages;
- authentication;
- authorization;
- JWT/session handling;
- centralized logging;
- audit orchestration;
- APEX pages.

---
## 13. Architectural Rule

The REST / ORDS adapter is responsible for transport concerns only.

The architectural rule is:

HTTP Request
    |
    v
REST / ORDS Adapter
    |
    v
Integration Boundary
    |
    v
PKG_IDENTITY.CREATE_USER
    |
    v
Existing Identity / Security / Persistence

The adapter must not become a second business-service layer.

---

## 14. Version and Status

- **Version:** v1
- **Status:** Architecture Baseline
- **Scope:** Create User REST / ORDS Adapter
- **Phase:** Phase 10
- **Implementation:** Deferred

---

## 15. Acceptance Criteria

The specification is complete when:

1. The endpoint is defined as POST /users.
2. The request JSON contains username, email, and password.
3. Request fields map to P_USERNAME, P_EMAIL, and P_PASSWORD.
4. User creation delegates exclusively to PKG_IDENTITY.CREATE_USER.
5. Successful creation returns user_id.
6. Successful creation uses HTTP 201 Created.
7. Transport-level error mappings are defined.
8. Plaintext passwords are never logged or exposed.
9. The adapter does not directly access Identity persistence tables.
10. No ORDS implementation is introduced by this specification.
11. Transaction ownership remains explicitly undefined.




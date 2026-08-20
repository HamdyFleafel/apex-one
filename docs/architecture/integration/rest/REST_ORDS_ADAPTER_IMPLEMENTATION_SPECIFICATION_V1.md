# REST / ORDS Adapter Implementation Specification v1

## 1. Purpose

This document defines the implementation specification for the future REST / ORDS adapter responsible for user creation in APEXONE.

The adapter implements the external HTTP transport boundary and delegates user creation exclusively to the existing Identity service API.

This specification defines the implementation contract required before actual ORDS implementation.

---

## 2. Scope

The adapter scope is limited to:

- HTTP request reception;
- request JSON parsing;
- transport-level validation;
- invocation of the Integration Boundary;
- delegation to `PKG_IDENTITY.CREATE_USER`;
- success response generation;
- error classification;
- HTTP status mapping;
- transport-level security handling.

---

## 3. Architectural Position

The adapter is a transport adapter.

It must not become a second Identity business-service layer.

The implementation flow is:

HTTP Client
    |
    v
ORDS REST Handler
    |
    v
REST / ORDS Adapter Boundary
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
JSON Response

---

## 4. Endpoint

| Property | Value |
|---|---|
| Method | POST |
| Endpoint | `/users` |
| Purpose | Create a new user |
| Request Content-Type | `application/json` |
| Response Content-Type | `application/json` |

The final ORDS module prefix remains an implementation deployment concern.

---

## 5. Request Contract

The request JSON contains exactly the transport fields required for user creation:

| Field | Type | Required | Sensitive |
|---|---|---:|---:|
| `username` | string | Yes | No |
| `email` | string | Yes | No |
| `password` | string | Yes | Yes |

Example:

{
  "username": "example_user",
  "email": "user@example.com",
  "password": "********"
}

---

## 6. Request Mapping

The adapter maps the HTTP request fields to the Identity service parameters:

request.username  -> P_USERNAME
request.email     -> P_EMAIL
request.password  -> P_PASSWORD

No additional Identity business rules are introduced by the adapter.

---

## 7. Transport Validation

The adapter validates the transport request before invoking the Identity service.

At minimum:

- request body must exist;
- request body must be valid JSON;
- `username` must be present;
- `email` must be present;
- `password` must be present.

Transport validation failures return HTTP `400 Bad Request`.

Identity-specific validation remains owned by `PKG_IDENTITY.CREATE_USER`.

---

## 8. Identity Service Invocation

User creation must delegate exclusively to:

`PKG_IDENTITY.CREATE_USER`

The adapter must not:

- insert into `APP_USERS`;
- insert into `APP_PASSWORD_HISTORY`;
- generate password salts;
- hash passwords;
- validate duplicate usernames;
- validate duplicate emails;
- implement Identity business rules.

---

## 9. Identity Service Contract

The Identity service function currently accepts:

`P_USERNAME`

`P_EMAIL`

`P_PASSWORD`

and returns:

`USER_ID`

The adapter must consume the returned `USER_ID` and use it as the REST success payload.

---

## 10. Success Response

Successful creation returns:

{
  "user_id": 12345
}

The value is the `USER_ID` returned by `PKG_IDENTITY.CREATE_USER`.

No database row, password data, salt, verifier, or internal persistence structure is exposed.

---

## 11. Success HTTP Status

Successful user creation returns:

`201 Created`

The response Content-Type is:

`application/json`

---

## 12. Identity Error Source

Identity errors are currently centralized through:

`PKG_ERRORS`

Identity-specific errors use:

`PKG_ERRORS.RAISE_IDENTITY_ERROR`

which currently maps to Oracle application error code:

`-20001`

The REST / ORDS adapter may classify `-20001` as the established Identity semantic error class and map it to HTTP `409 Conflict`. It must not parse raw Oracle message text to infer the error class.

---

## 13. Duplicate Username

When the username already exists, `PKG_IDENTITY.CREATE_USER` raises an Identity error.

Transport mapping:

`-20001` -> `409 Conflict`

The adapter must not perform a second duplicate-username query.

---

## 14. Duplicate Email

When the email already exists, `PKG_IDENTITY.CREATE_USER` raises an Identity error.

Transport mapping:

`-20001` -> `409 Conflict`

The adapter must not perform a second duplicate-email query.

---

## 15. Error Response

The baseline error response is:

{
  "error": {
    "code": "IDENTITY_ERROR",
    "message": "User creation failed"
  }
}

The external response must not expose:

- SQL statements;
- PL/SQL stack traces;
- database object names;
- internal persistence details;
- plaintext passwords;
- raw diagnostic information.

---

## 16. HTTP Error Mapping

| Condition | Source | HTTP Status |
|---|---|---:|
| Invalid JSON/request | Adapter | 400 Bad Request |
| Missing required field | Adapter | 400 Bad Request |
| Authentication failure | Future security boundary | 401 Unauthorized |
| Authorization failure | Future security boundary | 403 Forbidden |
| Duplicate username | Identity / -20001 | 409 Conflict |
| Duplicate email | Identity / -20001 | 409 Conflict |
| Unexpected application failure | Generic error | 500 Internal Server Error |

---

## 17. Error Classification

The adapter classifies errors by semantic meaning.

It must not create replacement business rules merely to identify errors.

Identity remains responsible for Identity semantics.

The adapter remains responsible for HTTP semantics.

---

## 18. Password Handling

The `password` request field is sensitive.

The implementation must:

- never log the plaintext password;
- never write the plaintext password to persistent storage;
- never include it in a response;
- never include it in diagnostics;
- pass it only to the Identity service invocation.

---

## 19. Transaction Boundary

The REST / ORDS adapter does not define transaction ownership.

The adapter must not introduce an independent commit or rollback policy.

Transaction ownership remains with the database implementation boundary invoking the Identity service.

---

## 20. ORDS Handler Responsibility

The future ORDS handler is responsible only for transport concerns.

It must:

1. receive the HTTP request;
2. obtain the JSON payload;
3. invoke the adapter boundary;
4. receive the result;
5. return the appropriate HTTP response.

Business logic must remain outside the ORDS handler.

---

## 21. ORDS Module Responsibility

The ORDS module configuration will define:

- module name;
- base path;
- template;
- HTTP method;
- handler;
- response behavior.

Exact ORDS naming and deployment configuration are intentionally deferred until implementation begins.

---

## 22. Integration Boundary

The implementation must preserve an explicit boundary between ORDS transport and Identity service logic.

Conceptually:

ORDS
  |
  v
REST Adapter Boundary
  |
  v
PKG_IDENTITY.CREATE_USER

The boundary exists to prevent transport concerns from leaking into Identity business logic.

---

## 23. Authentication

Authentication is not implemented by this specification.

The endpoint contract reserves authentication as a future security concern.

No authentication mechanism is to be invented during the ORDS implementation phase without an approved security specification.

---

## 24. Authorization

Authorization is not implemented by this specification.

Future authorization controls must be applied at the appropriate security boundary.

The REST adapter must not silently introduce role or privilege rules.

---

## 25. Logging and Diagnostics

The implementation must not log sensitive request data.

In particular:

`password` must never appear in:

- application logs;
- ORDS diagnostics;
- exception messages;
- debug output;
- audit messages.

Future centralized logging and audit orchestration remain separate concerns.

---

## 26. Implementation Non-Goals

This specification does not authorize implementation of:

- authentication;
- authorization;
- JWT;
- session management;
- centralized logging;
- audit orchestration;
- APEX pages;
- alternative Identity business logic;
- direct table access from REST;
- password hashing in REST;
- duplicate validation in REST.

---

## 27. Implementation Sequence

The implementation sequence shall be:

1. Confirm the specification baseline.
2. Confirm the existing Identity package contract.
3. Define the ORDS module.
4. Define the `/users` POST template.
5. Define the REST handler.
6. Parse and validate JSON.
7. Invoke `PKG_IDENTITY.CREATE_USER`.
8. Map the returned `USER_ID`.
9. Map Identity errors to HTTP responses.
10. Validate security handling.
11. Test success and failure scenarios.
12. Review the implementation against this specification.

No implementation step should introduce business logic outside the approved boundaries.

---

## 28. Acceptance Criteria

The implementation specification is accepted when:

1. `POST /users` is defined.
2. The request contains `username`, `email`, and `password`.
3. Fields map to `P_USERNAME`, `P_EMAIL`, and `P_PASSWORD`.
4. User creation delegates exclusively to `PKG_IDENTITY.CREATE_USER`.
5. Successful creation returns `user_id`.
6. Success uses HTTP `201 Created`.
7. Invalid transport requests return HTTP `400`.
8. Duplicate username returns HTTP `409`.
9. Duplicate email returns HTTP `409`.
10. Unexpected failures return HTTP `500`.
11. Authentication and authorization remain deferred.
12. Plaintext passwords are never exposed or logged.
13. REST does not directly access Identity persistence tables.
14. REST does not duplicate Identity business rules.
15. Transaction ownership remains explicitly undefined.
16. ORDS implementation remains aligned with the transport architecture.

---

## 29. Version and Status

- **Version:** v1
- **Status:** Implementation Baseline
- **Scope:** REST / ORDS User Creation Adapter
- **Phase:** Phase 10
- **Implementation:** Ready for controlled implementation
- **GitHub Synchronization:** Deferred until the agreed project synchronization point

---

## 30. Architectural Rule

The implementation must preserve the following rule:

HTTP Request
    |
    v
ORDS Transport
    |
    v
REST / ORDS Adapter Boundary
    |
    v
PKG_IDENTITY.CREATE_USER
    |
    v
Existing Identity / Security / Persistence

The REST / ORDS layer is not allowed to become a second business-service layer.

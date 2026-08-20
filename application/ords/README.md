# APEXONE ORDS

## Installation

Connect with an ORDS-enabled schema and run:

```text
@install_ords.sql
```

## Implemented endpoint

`POST /api/v1/users`

Request fields: `username`, `email`, `password`.

Execution path:

```text
ORDS -> PKG_INTEGRATION.CREATE_USER -> PKG_IDENTITY.CREATE_USER
```

HTTP mapping:

- `201` successful creation
- `400` invalid JSON or missing required fields
- `409` propagated Identity conflict (`SQLCODE = -20001`)
- `500` unexpected failure

The handler intentionally does not implement Identity business rules, direct table access, password hashing, or transaction ownership.

# APEXONE Final Clean Release

## Runtime-verified scope
- `PKG_ERRORS.raise_identity_error` reconciled to Oracle application error `-20001`.
- `PKG_INTEGRATION` specification and body install successfully from the repository root.
- `PKG_INTEGRATION.CREATE_USER` delegates to `PKG_IDENTITY.CREATE_USER`.
- ORDS schema `APEXONE` was REST-enabled during deployment.
- `POST /ords/apexone/api/v1/users` was runtime-tested.

## Verified HTTP outcomes
- Valid create: `201` with `user_id`.
- Missing required field: `400` / `INVALID_REQUEST`.
- Invalid JSON: `400` / `INVALID_REQUEST`.
- Duplicate username: `409` / `IDENTITY_ERROR`.
- Duplicate email: `409` / `IDENTITY_ERROR`.

## Install from repository root
1. `@database/modules/integration/install_integration.sql`
2. If not already enabled: run `ORDS.ENABLE_SCHEMA` for schema `APEXONE`.
3. `@application/ords/install_ords.sql`
4. `@database/modules/integration/tests/VERIFY_INTEGRATION_AND_ORDS.sql`
5. Run `application/ords/tests/SMOKE_TEST_CREATE_USER.ps1`.

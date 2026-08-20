
## Integration Module

The Integration module provides `PKG_INTEGRATION` as the thin database boundary used by external transports. It delegates Create User requests to `PKG_IDENTITY.CREATE_USER` without duplicating Identity business logic.

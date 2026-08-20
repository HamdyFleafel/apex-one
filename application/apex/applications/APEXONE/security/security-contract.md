# APEXONE Security Contract

## Authentication

APEX authentication is custom and delegates identity verification to the Identity database APIs.

APEX must not own password hashing, lockout rules, session persistence, or identity policy logic.

## Authorization

Authorization is RBAC and is evaluated through the Security database APIs.

APEX authorization schemes are adapters over database authorization contracts. They must not maintain a second role/permission model.

## Session

APEX session state is presentation/runtime state. Persistent application sessions are owned by the database Identity/Platform contracts.

## Rule

If a security rule exists in the database contract, it is not reimplemented in APEX page processes.

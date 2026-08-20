# APEXONE Tablespace Contract

- `APEXONE_DATA`: normal application tables and transactional security history.
- `APEXONE_INDEX`: normal application and supporting indexes.
- `APEXONE_AUDIT`: append-heavy audit trail tables and their indexes.

Audit objects:
- `APP_LOGIN_HISTORY` -> `APEXONE_AUDIT`
- `APP_SECURITY_AUDIT` -> `APEXONE_AUDIT`
- `PK_APP_LOGIN_HISTORY` -> `APEXONE_AUDIT`
- `PK_APP_SECURITY_AUDIT` -> `APEXONE_AUDIT`

Transactional security history:
- `APP_PASSWORD_HISTORY` -> `APEXONE_DATA`
- `PK_APP_PASSWORD_HISTORY`, `IX_APP_PASSWORD_HISTORY_USER` -> `APEXONE_INDEX`

Schema default tablespace: `APEXONE_DATA`. Object scripts must specify explicit placement.

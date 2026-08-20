-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Seed
-- Object Name    : SEED_ADMIN_USER
-- Object Type    : SCRIPT
-- File           : seed_admin_user.sql
-- Path           : database/seed/identity/seed_admin_user.sql
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development

---

-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : [hamdy.fleafel@belcofarms.com](mailto:hamdy.fleafel@belcofarms.com)
-- WhatsApp       : 0020 1010506080

---

-- Description    : Seeds the initial ADMIN application user using USERNAME
--                  as the logical business key. The script does not store
--                  plaintext passwords and is designed to be safely
--                  re-executed without creating duplicate users.

---

-- Created On     : 2026-08-07
-- Last Modified  : 2026-08-07

---

-- Change Log     :
--   2026-08-07  HF  Initial creation.

---

-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK ON

PROMPT
PROMPT ============================================================
PROMPT APEXONE - SEED ADMIN USER
PROMPT ============================================================

PROMPT [1] Seeding ADMIN user

MERGE INTO APP_USERS target
USING (
SELECT
'ADMIN'               AS USERNAME,
'[admin@apexone.local](mailto:admin@apexone.local)' AS EMAIL,
'ACTIVE'              AS ACCOUNT_STATUS_CODE
FROM DUAL
) source
ON (
UPPER(target.USERNAME) = UPPER(source.USERNAME)
)
WHEN MATCHED THEN
UPDATE SET
target.EMAIL = source.EMAIL,
target.ACCOUNT_STATUS_CODE = source.ACCOUNT_STATUS_CODE,
target.FAILED_LOGIN_COUNT = 0,
target.LOCKED_UNTIL = NULL
WHEN NOT MATCHED THEN
INSERT (
USERNAME,
EMAIL,
ACCOUNT_STATUS_CODE,
FAILED_LOGIN_COUNT,
LOCKED_UNTIL
)
VALUES (
source.USERNAME,
source.EMAIL,
source.ACCOUNT_STATUS_CODE,
0,
NULL
);

COMMIT;

PROMPT
PROMPT ============================================================
PROMPT ADMIN USER SEED COMPLETED
PROMPT ============================================================

PROMPT
PROMPT [ADMIN USER VERIFICATION]

SELECT
USER_ID,
USERNAME,
EMAIL,
ACCOUNT_STATUS_CODE,
FAILED_LOGIN_COUNT,
LOCKED_UNTIL
FROM APP_USERS
WHERE UPPER(USERNAME) = 'ADMIN';

PROMPT
PROMPT [ADMIN USER ROLE VERIFICATION]

SELECT
U.USERNAME,
R.ROLE_CODE
FROM APP_USER_ROLES UR
JOIN APP_USERS U
ON U.USER_ID = UR.USER_ID
JOIN APP_ROLES R
ON R.ROLE_ID = UR.ROLE_ID
WHERE UPPER(U.USERNAME) = 'ADMIN'
ORDER BY R.ROLE_CODE;

PROMPT
PROMPT ============================================================
PROMPT SEED ADMIN USER VERIFICATION COMPLETED
PROMPT ============================================================

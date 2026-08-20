-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Seed
-- Object Name    : SEED_ROLES
-- Object Type    : SCRIPT
-- File           : seed_roles.sql
-- Path           : database/seed/security/seed_roles.sql
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development

---

-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : [hamdy.fleafel@belcofarms.com](mailto:hamdy.fleafel@belcofarms.com)
-- WhatsApp       : 0020 1010506080

---

-- Description    : Seeds the initial Security roles using ROLE_CODE as the
--                  logical business key. The script is idempotent and may be
--                  safely executed multiple times without creating duplicates.

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
PROMPT APEXONE - SEED IDENTITY ROLES
PROMPT ============================================================

PROMPT [1] Seeding ADMIN role

MERGE INTO APP_ROLES target
USING (
SELECT
'ADMIN'         AS ROLE_CODE,
'Administrator' AS ROLE_NAME
FROM DUAL
) source
ON (
target.ROLE_CODE = source.ROLE_CODE
)
WHEN MATCHED THEN
UPDATE SET
target.ROLE_NAME = source.ROLE_NAME
WHEN NOT MATCHED THEN
INSERT (
ROLE_CODE,
ROLE_NAME
)
VALUES (
source.ROLE_CODE,
source.ROLE_NAME
);

COMMIT;

PROMPT
PROMPT ============================================================
PROMPT IDENTITY ROLES SEED COMPLETED
PROMPT ============================================================

PROMPT
PROMPT Seeded Role Count:

SELECT COUNT(*) AS ROLE_COUNT
FROM APP_ROLES;

PROMPT
PROMPT [ROLE VERIFICATION]

SELECT
ROLE_ID,
ROLE_CODE,
ROLE_NAME
FROM APP_ROLES
ORDER BY ROLE_CODE;

PROMPT
PROMPT [ADMIN ROLE VERIFICATION]

SELECT
ROLE_ID,
ROLE_CODE,
ROLE_NAME
FROM APP_ROLES
WHERE ROLE_CODE = 'ADMIN';

PROMPT
PROMPT ============================================================
PROMPT SEED ROLES VERIFICATION COMPLETED
PROMPT ============================================================

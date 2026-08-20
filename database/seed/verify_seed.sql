-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Platform
-- Component      : Seed Verification
-- Object Name    : VERIFY_SEED
-- Object Type    : SCRIPT
-- File           : verify_seed.sql
-- Path           : database\seed\verify_seed.sql
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development

---

-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : [hamdy.fleafel@belcofarms.com](mailto:hamdy.fleafel@belcofarms.com)
-- WhatsApp       : 0020 1010506080

---

-- Description    : Verifies centralized platform seed data and validates
--                  core, configuration, security, identity, notification,
--                  and workflow seed records.
----------------------------------------------

--                  The script also verifies the ADMIN user, assigned roles,
--                  and role-permission relationships.

---

-- Created On     : 2026-08-07
-- Last Modified  : 2026-08-07

---

-- Change Log     :
--   2026-08-07  HF  Initial centralized Seed verification script.
--   2026-08-07  HF  Added ADMIN user verification.
--   2026-08-07  HF  Added role verification for ADMIN.
--   2026-08-07  HF  Added role-permission matrix verification.

---

-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK ON

PROMPT
PROMPT ============================================================
PROMPT APEXONE - FINAL SEED VERIFICATION
PROMPT ============================================================

PROMPT
PROMPT [1] CORE

SELECT
COUNT(*) AS ROW_COUNT
FROM APP_SCHEMA_VERSION;

PROMPT
PROMPT [2] CONFIGURATION GROUPS

SELECT
COUNT(*) AS ROW_COUNT
FROM APP_CONFIG_GROUPS;

PROMPT
PROMPT [3] CONFIGURATION

SELECT
COUNT(*) AS ROW_COUNT
FROM APP_CONFIG;

PROMPT
PROMPT [4] PERMISSIONS

SELECT
COUNT(*) AS PERMISSION_COUNT
FROM APP_PERMISSIONS;

PROMPT
PROMPT [5] ROLES

SELECT
COUNT(*) AS ROLE_COUNT
FROM APP_ROLES;

PROMPT
PROMPT [6] ROLE PERMISSIONS

SELECT
COUNT(*) AS ROLE_PERMISSION_COUNT
FROM APP_ROLE_PERMISSIONS;

PROMPT
PROMPT [7] USERS

SELECT
COUNT(*) AS USER_COUNT
FROM APP_USERS;

PROMPT
PROMPT [8] USER ROLES

SELECT
COUNT(*) AS USER_ROLE_COUNT
FROM APP_USER_ROLES;

PROMPT
PROMPT [9] NOTIFICATION TEMPLATES

SELECT
COUNT(*) AS TEMPLATE_COUNT
FROM APP_NOTIFICATION_TEMPLATES;

PROMPT
PROMPT [10] WORKFLOW DEFINITIONS

SELECT
COUNT(*) AS WORKFLOW_COUNT
FROM APP_WORKFLOW_DEFINITIONS;

PROMPT
PROMPT ============================================================
PROMPT ADMIN USER
PROMPT ============================================================

SELECT
USER_ID,
USERNAME,
EMAIL,
ACCOUNT_STATUS_CODE,
FAILED_LOGIN_COUNT,
LOCKED_UNTIL,
LAST_LOGIN_AT
FROM APP_USERS
WHERE UPPER(USERNAME) = 'ADMIN';

PROMPT
PROMPT ============================================================
PROMPT ADMIN ROLE
PROMPT ============================================================

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
PROMPT ADMIN ROLE PERMISSION MATRIX
PROMPT ============================================================

SELECT
R.ROLE_CODE,
P.PERMISSION_CODE
FROM APP_ROLE_PERMISSIONS RP
JOIN APP_ROLES R
ON R.ROLE_ID = RP.ROLE_ID
JOIN APP_PERMISSIONS P
ON P.PERMISSION_ID = RP.PERMISSION_ID
WHERE R.ROLE_CODE = 'ADMIN'
ORDER BY P.PERMISSION_CODE;

PROMPT
PROMPT ============================================================
PROMPT ADMIN PERMISSION COUNT
PROMPT ============================================================

SELECT
R.ROLE_CODE,
COUNT(*) AS PERMISSION_COUNT
FROM APP_ROLE_PERMISSIONS RP
JOIN APP_ROLES R
ON R.ROLE_ID = RP.ROLE_ID
WHERE R.ROLE_CODE = 'ADMIN'
GROUP BY R.ROLE_CODE;

PROMPT
PROMPT ============================================================
PROMPT ORPHAN ROLE PERMISSIONS
PROMPT ============================================================

SELECT
COUNT(*) AS ORPHAN_ROLE_PERMISSION_COUNT
FROM APP_ROLE_PERMISSIONS RP
WHERE NOT EXISTS (
SELECT 1
FROM APP_ROLES R
WHERE R.ROLE_ID = RP.ROLE_ID
)
OR NOT EXISTS (
SELECT 1
FROM APP_PERMISSIONS P
WHERE P.PERMISSION_ID = RP.PERMISSION_ID
);

PROMPT
PROMPT ============================================================
PROMPT ORPHAN USER ROLES
PROMPT ============================================================

SELECT
COUNT(*) AS ORPHAN_USER_ROLE_COUNT
FROM APP_USER_ROLES UR
WHERE NOT EXISTS (
SELECT 1
FROM APP_USERS U
WHERE U.USER_ID = UR.USER_ID
)
OR NOT EXISTS (
SELECT 1
FROM APP_ROLES R
WHERE R.ROLE_ID = UR.ROLE_ID
);

PROMPT
PROMPT ============================================================
PROMPT DUPLICATE PERMISSION CODES
PROMPT ============================================================

SELECT
PERMISSION_CODE,
COUNT(*) AS DUPLICATE_COUNT
FROM APP_PERMISSIONS
GROUP BY PERMISSION_CODE
HAVING COUNT(*) > 1
ORDER BY PERMISSION_CODE;

PROMPT
PROMPT ============================================================
PROMPT DUPLICATE ROLE CODES
PROMPT ============================================================

SELECT
ROLE_CODE,
COUNT(*) AS DUPLICATE_COUNT
FROM APP_ROLES
GROUP BY ROLE_CODE
HAVING COUNT(*) > 1
ORDER BY ROLE_CODE;

PROMPT
PROMPT ============================================================
PROMPT DUPLICATE ADMIN ROLE PERMISSIONS
PROMPT ============================================================

SELECT
R.ROLE_CODE,
P.PERMISSION_CODE,
COUNT(*) AS DUPLICATE_COUNT
FROM APP_ROLE_PERMISSIONS RP
JOIN APP_ROLES R
ON R.ROLE_ID = RP.ROLE_ID
JOIN APP_PERMISSIONS P
ON P.PERMISSION_ID = RP.PERMISSION_ID
WHERE R.ROLE_CODE = 'ADMIN'
GROUP BY
R.ROLE_CODE,
P.PERMISSION_CODE
HAVING COUNT(*) > 1
ORDER BY P.PERMISSION_CODE;

PROMPT
PROMPT ============================================================
PROMPT FINAL SEED VERIFICATION COMPLETED
PROMPT ============================================================

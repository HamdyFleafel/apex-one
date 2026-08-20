-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Seed
-- Object Name    : SEED_ROLE_PERMISSIONS
-- Object Type    : SCRIPT
-- File           : seed_role_permissions.sql
-- Path           : database/seed/security/seed_role_permissions.sql
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development

---

-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : [hamdy.fleafel@belcofarms.com](mailto:hamdy.fleafel@belcofarms.com)
-- WhatsApp       : 0020 1010506080

---

-- Description    : Seeds the ADMIN role-permission assignments using
--                  ROLE_CODE and PERMISSION_CODE as logical business keys.
--                  The script is idempotent and may be safely executed
--                  multiple times without creating duplicate assignments.

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
PROMPT APEXONE - SEED ADMIN ROLE PERMISSIONS
PROMPT ============================================================


DECLARE

    l_role_id NUMBER;

BEGIN

    SELECT ROLE_ID
    INTO l_role_id
    FROM APP_ROLES
    WHERE ROLE_CODE = 'ADMIN';


    INSERT INTO APP_ROLE_PERMISSIONS
    (
        ROLE_ID,
        PERMISSION_ID
    )
    SELECT
        l_role_id,
        P.PERMISSION_ID
    FROM APP_PERMISSIONS P
    WHERE P.PERMISSION_CODE IN
    (
        'USER.CREATE',
        'USER.READ',
        'USER.UPDATE',
        'USER.LOCK',
        'ROLE.CREATE',
        'ROLE.READ',
        'ROLE.UPDATE',
        'PERMISSION.READ'
    )
    AND NOT EXISTS
    (
        SELECT 1
        FROM APP_ROLE_PERMISSIONS RP
        WHERE RP.ROLE_ID = l_role_id
        AND RP.PERMISSION_ID = P.PERMISSION_ID
    );


    DBMS_OUTPUT.PUT_LINE(
        'ADMIN role permissions seeded.'
    );


END;
/

COMMIT;


PROMPT
PROMPT ============================================================
PROMPT ROLE PERMISSIONS VERIFICATION
PROMPT ============================================================


SELECT
    R.ROLE_CODE,
    P.PERMISSION_CODE
FROM APP_ROLE_PERMISSIONS RP
JOIN APP_ROLES R
ON R.ROLE_ID = RP.ROLE_ID
JOIN APP_PERMISSIONS P
ON P.PERMISSION_ID = RP.PERMISSION_ID
WHERE R.ROLE_CODE='ADMIN'
ORDER BY P.PERMISSION_CODE;


PROMPT
PROMPT ============================================================
PROMPT SEED ROLE PERMISSIONS COMPLETED
PROMPT ============================================================
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Seed
-- Object Name    : SEED_PERMISSIONS
-- Object Type    : SCRIPT
-- File           : seed_permissions.sql
-- Path           : database\seed\security\seed_permissions.sql
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Seeds baseline Identity/RBAC permissions required by the
--                  APEXONE platform.
--
--                  The script is designed to be idempotent and may be executed
--                  repeatedly without creating duplicate permissions.
--
--                  Permission identity is based on PERMISSION_CODE and not on
--                  the generated PERMISSION_ID.
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-07
-- Last Modified  : 2026-08-07
-- -----------------------------------------------------------------------------
-- Change Log     :
--   2026-08-07  HF  Initial creation.
--   2026-08-07  HF  Added idempotent permission seeding using MERGE.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK ON

PROMPT ============================================================
PROMPT APEXONE - SEED IDENTITY PERMISSIONS
PROMPT ============================================================

PROMPT [1] Seeding USER.CREATE

MERGE INTO APP_PERMISSIONS target
USING (
    SELECT
        'USER.CREATE' AS PERMISSION_CODE,
        'Create User' AS PERMISSION_NAME,
        'Allows creation of application users.' AS DESCRIPTION
    FROM DUAL
) source
ON (
    target.PERMISSION_CODE = source.PERMISSION_CODE
)
WHEN MATCHED THEN
    UPDATE SET
        target.PERMISSION_NAME = source.PERMISSION_NAME,
        target.DESCRIPTION     = source.DESCRIPTION,
        target.STATUS          = 'ACTIVE',
        target.IS_DELETED      = 'N',
        target.UPDATED_AT      = SYSTIMESTAMP,
        target.UPDATED_BY      = USER
WHEN NOT MATCHED THEN
    INSERT (
        PERMISSION_CODE,
        PERMISSION_NAME,
        DESCRIPTION,
        STATUS,
        IS_DELETED
    )
    VALUES (
        source.PERMISSION_CODE,
        source.PERMISSION_NAME,
        source.DESCRIPTION,
        'ACTIVE',
        'N'
    );

PROMPT [2] Seeding USER.READ

MERGE INTO APP_PERMISSIONS target
USING (
    SELECT
        'USER.READ' AS PERMISSION_CODE,
        'Read User' AS PERMISSION_NAME,
        'Allows viewing application user information.' AS DESCRIPTION
    FROM DUAL
) source
ON (
    target.PERMISSION_CODE = source.PERMISSION_CODE
)
WHEN MATCHED THEN
    UPDATE SET
        target.PERMISSION_NAME = source.PERMISSION_NAME,
        target.DESCRIPTION     = source.DESCRIPTION,
        target.STATUS          = 'ACTIVE',
        target.IS_DELETED      = 'N',
        target.UPDATED_AT      = SYSTIMESTAMP,
        target.UPDATED_BY      = USER
WHEN NOT MATCHED THEN
    INSERT (
        PERMISSION_CODE,
        PERMISSION_NAME,
        DESCRIPTION,
        STATUS,
        IS_DELETED
    )
   VALUES (
    source.PERMISSION_CODE,
    source.PERMISSION_NAME,
    source.DESCRIPTION,
    'ACTIVE',
    'N'
);

PROMPT [3] Seeding USER.UPDATE

MERGE INTO APP_PERMISSIONS target
USING (
    SELECT
        'USER.UPDATE' AS PERMISSION_CODE,
        'Update User' AS PERMISSION_NAME,
        'Allows modification of application user information.' AS DESCRIPTION
    FROM DUAL
) source
ON (
    target.PERMISSION_CODE = source.PERMISSION_CODE
)
WHEN MATCHED THEN
    UPDATE SET
        target.PERMISSION_NAME = source.PERMISSION_NAME,
        target.DESCRIPTION     = source.DESCRIPTION,
        target.STATUS          = 'ACTIVE',
        target.IS_DELETED      = 'N',
        target.UPDATED_AT      = SYSTIMESTAMP,
        target.UPDATED_BY      = USER
WHEN NOT MATCHED THEN
    INSERT (
        PERMISSION_CODE,
        PERMISSION_NAME,
        DESCRIPTION,
        STATUS,
        IS_DELETED
    )
    VALUES (
        source.PERMISSION_CODE,
        source.PERMISSION_NAME,
        source.DESCRIPTION,
        'ACTIVE',
        'N'
    );

PROMPT [4] Seeding USER.LOCK

MERGE INTO APP_PERMISSIONS target
USING (
    SELECT
        'USER.LOCK' AS PERMISSION_CODE,
        'Lock User' AS PERMISSION_NAME,
        'Allows locking and unlocking application user accounts.' AS DESCRIPTION
    FROM DUAL
) source
ON (
    target.PERMISSION_CODE = source.PERMISSION_CODE
)
WHEN MATCHED THEN
    UPDATE SET
        target.PERMISSION_NAME = source.PERMISSION_NAME,
        target.DESCRIPTION     = source.DESCRIPTION,
        target.STATUS          = 'ACTIVE',
        target.IS_DELETED      = 'N',
        target.UPDATED_AT      = SYSTIMESTAMP,
        target.UPDATED_BY      = USER
WHEN NOT MATCHED THEN
    INSERT (
        PERMISSION_CODE,
        PERMISSION_NAME,
        DESCRIPTION,
        STATUS,
        IS_DELETED
    )
    VALUES (
        source.PERMISSION_CODE,
        source.PERMISSION_NAME,
        source.DESCRIPTION,
        'ACTIVE',
        'N'
    );

PROMPT [5] Seeding ROLE.CREATE

MERGE INTO APP_PERMISSIONS target
USING (
    SELECT
        'ROLE.CREATE' AS PERMISSION_CODE,
        'Create Role' AS PERMISSION_NAME,
        'Allows creation of application roles.' AS DESCRIPTION
    FROM DUAL
) source
ON (
    target.PERMISSION_CODE = source.PERMISSION_CODE
)
WHEN MATCHED THEN
    UPDATE SET
        target.PERMISSION_NAME = source.PERMISSION_NAME,
        target.DESCRIPTION     = source.DESCRIPTION,
        target.STATUS          = 'ACTIVE',
        target.IS_DELETED      = 'N',
        target.UPDATED_AT      = SYSTIMESTAMP,
        target.UPDATED_BY      = USER
WHEN NOT MATCHED THEN
    INSERT (
        PERMISSION_CODE,
        PERMISSION_NAME,
        DESCRIPTION,
        STATUS,
        IS_DELETED
    )
    VALUES (
        source.PERMISSION_CODE,
        source.PERMISSION_NAME,
        source.DESCRIPTION,
        'ACTIVE',
        'N'
    );

PROMPT [6] Seeding ROLE.READ

MERGE INTO APP_PERMISSIONS target
USING (
    SELECT
        'ROLE.READ' AS PERMISSION_CODE,
        'Read Role' AS PERMISSION_NAME,
        'Allows viewing application roles.' AS DESCRIPTION
    FROM DUAL
) source
ON (
    target.PERMISSION_CODE = source.PERMISSION_CODE
)
WHEN MATCHED THEN
    UPDATE SET
        target.PERMISSION_NAME = source.PERMISSION_NAME,
        target.DESCRIPTION     = source.DESCRIPTION,
        target.STATUS          = 'ACTIVE',
        target.IS_DELETED      = 'N',
        target.UPDATED_AT      = SYSTIMESTAMP,
        target.UPDATED_BY      = USER
WHEN NOT MATCHED THEN
    INSERT (
        PERMISSION_CODE,
        PERMISSION_NAME,
        DESCRIPTION,
        STATUS,
        IS_DELETED
    )
    VALUES (
        source.PERMISSION_CODE,
        source.PERMISSION_NAME,
        source.DESCRIPTION,
        'ACTIVE',
        'N'
    );

PROMPT [7] Seeding ROLE.UPDATE

MERGE INTO APP_PERMISSIONS target
USING (
    SELECT
        'ROLE.UPDATE' AS PERMISSION_CODE,
        'Update Role' AS PERMISSION_NAME,
        'Allows modification of application roles.' AS DESCRIPTION
    FROM DUAL
) source
ON (
    target.PERMISSION_CODE = source.PERMISSION_CODE
)
WHEN MATCHED THEN
    UPDATE SET
        target.PERMISSION_NAME = source.PERMISSION_NAME,
        target.DESCRIPTION     = source.DESCRIPTION,
        target.STATUS          = 'ACTIVE',
        target.IS_DELETED      = 'N',
        target.UPDATED_AT      = SYSTIMESTAMP,
        target.UPDATED_BY      = USER
WHEN NOT MATCHED THEN
    INSERT (
        PERMISSION_CODE,
        PERMISSION_NAME,
        DESCRIPTION,
        STATUS,
        IS_DELETED
    )
    VALUES (
        source.PERMISSION_CODE,
        source.PERMISSION_NAME,
        source.DESCRIPTION,
        'ACTIVE',
        'N'
    );

PROMPT [8] Seeding PERMISSION.READ

MERGE INTO APP_PERMISSIONS target
USING (
    SELECT
        'PERMISSION.READ' AS PERMISSION_CODE,
        'Read Permission' AS PERMISSION_NAME,
        'Allows viewing application permissions.' AS DESCRIPTION
    FROM DUAL
) source
ON (
    target.PERMISSION_CODE = source.PERMISSION_CODE
)
WHEN MATCHED THEN
    UPDATE SET
        target.PERMISSION_NAME = source.PERMISSION_NAME,
        target.DESCRIPTION     = source.DESCRIPTION,
        target.STATUS          = 'ACTIVE',
        target.IS_DELETED      = 'N',
        target.UPDATED_AT      = SYSTIMESTAMP,
        target.UPDATED_BY      = USER
WHEN NOT MATCHED THEN
    INSERT (
        PERMISSION_CODE,
        PERMISSION_NAME,
        DESCRIPTION,
        STATUS,
        IS_DELETED
    )
    VALUES (
        source.PERMISSION_CODE,
        source.PERMISSION_NAME,
        source.DESCRIPTION,
        'ACTIVE',
        'N'
    );

COMMIT;

PROMPT
PROMPT ============================================================
PROMPT IDENTITY PERMISSIONS SEED COMPLETED
PROMPT ============================================================

PROMPT Seeded Permission Count:

SELECT COUNT(*) AS PERMISSION_COUNT
FROM APP_PERMISSIONS
WHERE PERMISSION_CODE IN (
    'USER.CREATE',
    'USER.READ',
    'USER.UPDATE',
    'USER.LOCK',
    'ROLE.CREATE',
    'ROLE.READ',
    'ROLE.UPDATE',
    'PERMISSION.READ'
);

PROMPT
PROMPT ============================================================
PROMPT SEED PERMISSIONS VERIFICATION COMPLETED
PROMPT ============================================================

-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : CHK_APP_PERMISSIONS_CODE_UPPER
-- Object Type    : CHECK CONSTRAINT
-- File           : app_permissions_code_ck.sql
-- Path           : database/modules/identity/constraints/app_permissions_code_ck.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Ensures that permission codes are stored in uppercase.
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-05
-- Last Modified  : 2026-08-05
-- -----------------------------------------------------------------------------
-- Change Log     :
--   2026-08-05  HF  Initial creation.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

PROMPT ============================================================================
PROMPT Adding CHK_APP_PERMISSIONS_CODE_UPPER
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'CHK_APP_PERMISSIONS_CODE_UPPER';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
            ALTER TABLE APP_PERMISSIONS
            ADD CONSTRAINT CHK_APP_PERMISSIONS_CODE_UPPER
            CHECK (PERMISSION_CODE = UPPER(PERMISSION_CODE))
        ]';

        DBMS_OUTPUT.PUT_LINE(
            'CHK_APP_PERMISSIONS_CODE_UPPER created.'
        );

    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'CHK_APP_PERMISSIONS_CODE_UPPER already exists.'
        );

    END IF;
END;
/

COMMIT;

PROMPT Completed.
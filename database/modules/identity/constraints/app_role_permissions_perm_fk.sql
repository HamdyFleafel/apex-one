-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : FK_RP_PERMISSION
-- Object Type    : FOREIGN KEY CONSTRAINT
-- File           : app_role_permissions_perm_fk.sql
-- Path           : database/modules/identity/constraints/app_role_permissions_perm_fk.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Links PERMISSION_ID in APP_ROLE_PERMISSIONS to APP_PERMISSIONS.
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
PROMPT Adding FK_RP_PERMISSION
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'FK_RP_PERMISSION'
       AND TABLE_NAME      = 'APP_ROLE_PERMISSIONS'
       AND CONSTRAINT_TYPE = 'R';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
            ALTER TABLE APP_ROLE_PERMISSIONS
            ADD CONSTRAINT FK_RP_PERMISSION
            FOREIGN KEY (PERMISSION_ID)
            REFERENCES APP_PERMISSIONS (PERMISSION_ID)
        ]';

        DBMS_OUTPUT.PUT_LINE('FK_RP_PERMISSION created.');

    ELSE
        DBMS_OUTPUT.PUT_LINE('FK_RP_PERMISSION already exists.');
    END IF;

END;
/

COMMIT;
PROMPT Completed.
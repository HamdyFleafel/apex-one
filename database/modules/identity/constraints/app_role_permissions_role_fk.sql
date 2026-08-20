-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : FK_RP_ROLE
-- Object Type    : FOREIGN KEY CONSTRAINT
-- File           : app_role_permissions_role_fk.sql
-- Path           : database/modules/identity/constraints/app_role_permissions_role_fk.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Links ROLE_ID in APP_ROLE_PERMISSIONS to APP_ROLES.
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
PROMPT Adding FK_RP_ROLE
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'FK_RP_ROLE'
       AND TABLE_NAME      = 'APP_ROLE_PERMISSIONS'
       AND CONSTRAINT_TYPE = 'R';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
            ALTER TABLE APP_ROLE_PERMISSIONS
            ADD CONSTRAINT FK_RP_ROLE
            FOREIGN KEY (ROLE_ID)
            REFERENCES APP_ROLES (ROLE_ID)
        ]';

        DBMS_OUTPUT.PUT_LINE('FK_RP_ROLE created.');

    ELSE
        DBMS_OUTPUT.PUT_LINE('FK_RP_ROLE already exists.');
    END IF;

END;
/

COMMIT;
PROMPT Completed.
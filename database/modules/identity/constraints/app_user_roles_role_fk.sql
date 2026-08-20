-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : FK_UR_ROLE
-- Object Type    : FOREIGN KEY CONSTRAINT
-- File           : app_user_roles_role_fk.sql
-- Path           : database/modules/identity/constraints/app_user_roles_role_fk.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Links ROLE_ID in APP_USER_ROLES to APP_ROLES.
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
PROMPT Adding FK_UR_ROLE
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'FK_UR_ROLE'
       AND TABLE_NAME      = 'APP_USER_ROLES'
       AND CONSTRAINT_TYPE = 'R';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
            ALTER TABLE APP_USER_ROLES
            ADD CONSTRAINT FK_UR_ROLE
            FOREIGN KEY (ROLE_ID)
            REFERENCES APP_ROLES (ROLE_ID)
        ]';

        DBMS_OUTPUT.PUT_LINE('FK_UR_ROLE created.');

    ELSE
        DBMS_OUTPUT.PUT_LINE('FK_UR_ROLE already exists.');
    END IF;

END;
/

COMMIT;
PROMPT Completed.
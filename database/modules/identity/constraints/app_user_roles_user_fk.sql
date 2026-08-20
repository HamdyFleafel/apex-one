-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : FK_UR_USER
-- Object Type    : FOREIGN KEY CONSTRAINT
-- File           : app_user_roles_user_fk.sql
-- Path           : database/modules/identity/constraints/app_user_roles_user_fk.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Links USER_ID in APP_USER_ROLES to APP_USERS.
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
PROMPT Adding FK_UR_USER
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'FK_UR_USER'
       AND TABLE_NAME      = 'APP_USER_ROLES'
       AND CONSTRAINT_TYPE = 'R';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
            ALTER TABLE APP_USER_ROLES
            ADD CONSTRAINT FK_UR_USER
            FOREIGN KEY (USER_ID)
            REFERENCES APP_USERS (USER_ID)
        ]';

        DBMS_OUTPUT.PUT_LINE('FK_UR_USER created.');

    ELSE
        DBMS_OUTPUT.PUT_LINE('FK_UR_USER already exists.');
    END IF;

END;
/

COMMIT;
PROMPT Completed.
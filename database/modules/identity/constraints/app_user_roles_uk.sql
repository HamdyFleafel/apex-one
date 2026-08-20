-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : UK_USER_ROLE
-- Object Type    : UNIQUE CONSTRAINT
-- File           : app_user_roles_uk.sql
-- Path           : database/modules/identity/constraints/app_user_roles_uk.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Prevents duplicate user-role assignments.
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
PROMPT Adding UK_USER_ROLE
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'UK_USER_ROLE'
       AND TABLE_NAME      = 'APP_USER_ROLES'
       AND CONSTRAINT_TYPE = 'U';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
            ALTER TABLE APP_USER_ROLES
            ADD CONSTRAINT UK_USER_ROLE
            UNIQUE (USER_ID, ROLE_ID)
                        USING INDEX TABLESPACE APEXONE_INDEX
        ]';

        DBMS_OUTPUT.PUT_LINE('UK_USER_ROLE created.');

    ELSE
        DBMS_OUTPUT.PUT_LINE('UK_USER_ROLE already exists.');
    END IF;

END;
/

COMMIT;
PROMPT Completed.
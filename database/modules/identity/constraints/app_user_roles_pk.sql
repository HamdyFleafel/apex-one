-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : PK_APP_USER_ROLES
-- Object Type    : PRIMARY KEY CONSTRAINT
-- File           : app_user_roles_pk.sql
-- Path           : database/modules/identity/constraints/app_user_roles_pk.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Creates primary key for APP_USER_ROLES.
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
PROMPT Adding PK_APP_USER_ROLES
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'PK_APP_USER_ROLES'
       AND TABLE_NAME      = 'APP_USER_ROLES'
       AND CONSTRAINT_TYPE = 'P';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
            ALTER TABLE APP_USER_ROLES
            ADD CONSTRAINT PK_APP_USER_ROLES
            PRIMARY KEY (USER_ROLE_ID)
                        USING INDEX TABLESPACE APEXONE_INDEX
        ]';

        DBMS_OUTPUT.PUT_LINE('PK_APP_USER_ROLES created.');

    ELSE

        DBMS_OUTPUT.PUT_LINE('PK_APP_USER_ROLES already exists.');

    END IF;

END;
/

COMMIT;

PROMPT Completed.
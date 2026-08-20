-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : PK_APP_USERS
-- Object Type    : PRIMARY KEY CONSTRAINT
-- File           : app_users_pk.sql
-- Path           : database/modules/identity/constraints/app_users_pk.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Creates primary key for APP_USERS.
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
PROMPT Adding PK_APP_USERS
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'PK_APP_USERS'
       AND TABLE_NAME      = 'APP_USERS'
       AND CONSTRAINT_TYPE = 'P';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
            ALTER TABLE APP_USERS
            ADD CONSTRAINT PK_APP_USERS
            PRIMARY KEY (USER_ID)
                        USING INDEX TABLESPACE APEXONE_INDEX
        ]';

        DBMS_OUTPUT.PUT_LINE('PK_APP_USERS created.');

    ELSE

        DBMS_OUTPUT.PUT_LINE('PK_APP_USERS already exists.');

    END IF;

END;
/

COMMIT;

PROMPT Completed.
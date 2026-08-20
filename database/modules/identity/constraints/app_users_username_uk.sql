-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : UK_APP_USERS_USERNAME
-- Object Type    : UNIQUE CONSTRAINT
-- File           : app_users_username_uk.sql
-- Path           : database/modules/identity/constraints/app_users_username_uk.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Ensures USERNAME is unique.
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-05
-- Last Modified  : 2026-08-05
-- -----------------------------------------------------------------------------
-- Change Log     :
--   2026-08-05  HF  Initial creation.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

PROMPT Adding UK_APP_USERS_USERNAME

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'UK_APP_USERS_USERNAME'
       AND TABLE_NAME      = 'APP_USERS'
       AND CONSTRAINT_TYPE = 'U';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE '
            ALTER TABLE APP_USERS
            ADD CONSTRAINT UK_APP_USERS_USERNAME
            UNIQUE (USERNAME)
                       USING INDEX TABLESPACE APEXONE_INDEX
        ';

        DBMS_OUTPUT.PUT_LINE('UK_APP_USERS_USERNAME created.');

    ELSE
        DBMS_OUTPUT.PUT_LINE('UK_APP_USERS_USERNAME already exists.');
    END IF;

END;
/

COMMIT;
PROMPT Completed.
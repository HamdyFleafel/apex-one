-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : UK_APP_USERS_EMAIL
-- Object Type    : UNIQUE CONSTRAINT
-- File           : app_users_email_uk.sql
-- Path           : database/modules/identity/constraints/app_users_email_uk.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Ensures EMAIL is unique in APP_USERS table.
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
PROMPT Adding UK_APP_USERS_EMAIL
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'UK_APP_USERS_EMAIL'
       AND TABLE_NAME      = 'APP_USERS'
       AND CONSTRAINT_TYPE = 'U';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
            ALTER TABLE APP_USERS
            ADD CONSTRAINT UK_APP_USERS_EMAIL
            UNIQUE (EMAIL)
                        USING INDEX TABLESPACE APEXONE_INDEX
        ]';

        DBMS_OUTPUT.PUT_LINE('UK_APP_USERS_EMAIL created.');

    ELSE

        DBMS_OUTPUT.PUT_LINE('UK_APP_USERS_EMAIL already exists.');

    END IF;

END;
/

COMMIT;

PROMPT Completed.
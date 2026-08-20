-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : PK_APP_LOGIN_ATTEMPTS
-- Object Type    : PRIMARY KEY CONSTRAINT
-- File           : app_login_attempts_pk.sql
-- Path           : database/modules/identity/constraints/app_login_attempts_pk.sql
-- Schema         : APEXONE
-- Version        : 1.6.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Primary key constraint for APP_LOGIN_ATTEMPTS.
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
PROMPT Adding PK_APP_LOGIN_ATTEMPTS
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'PK_APP_LOGIN_ATTEMPTS'
       AND TABLE_NAME      = 'APP_LOGIN_ATTEMPTS'
       AND CONSTRAINT_TYPE = 'P';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE '
            ALTER TABLE APP_LOGIN_ATTEMPTS
            ADD CONSTRAINT PK_APP_LOGIN_ATTEMPTS
            PRIMARY KEY (ATTEMPT_ID)
                        USING INDEX TABLESPACE APEXONE_INDEX
        ';

        DBMS_OUTPUT.PUT_LINE('PK_APP_LOGIN_ATTEMPTS created.');

    ELSE
        DBMS_OUTPUT.PUT_LINE('PK_APP_LOGIN_ATTEMPTS already exists.');
    END IF;

END;
/

COMMIT;

PROMPT Completed.
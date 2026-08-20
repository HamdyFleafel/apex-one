-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Constraints
-- Object Name    : PK_APP_LOGIN_HISTORY
-- Object Type    : PRIMARY KEY CONSTRAINT
-- File           : app_login_history_pk.sql
-- Path           : database/modules/security/constraints/app_login_history_pk.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Primary key constraint for APP_LOGIN_HISTORY.
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
PROMPT Adding PK_APP_LOGIN_HISTORY
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'PK_APP_LOGIN_HISTORY'
       AND TABLE_NAME      = 'APP_LOGIN_HISTORY'
       AND CONSTRAINT_TYPE = 'P';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE '
            ALTER TABLE APP_LOGIN_HISTORY
            ADD CONSTRAINT PK_APP_LOGIN_HISTORY
            PRIMARY KEY (LOGIN_ID)
                       USING INDEX TABLESPACE APEXONE_AUDIT
        ';

        DBMS_OUTPUT.PUT_LINE('PK_APP_LOGIN_HISTORY created.');

    ELSE
        DBMS_OUTPUT.PUT_LINE('PK_APP_LOGIN_HISTORY already exists.');
    END IF;

END;
/

COMMIT;

PROMPT Completed.
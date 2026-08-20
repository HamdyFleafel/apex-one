-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : UK_APP_SESSION_TOKEN
-- Object Type    : UNIQUE CONSTRAINT
-- File           : app_sessions_token_uk.sql
-- Path           : database/modules/identity/constraints/app_sessions_token_uk.sql
-- Schema         : APEXONE
-- Version        : 1.5.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Ensures SESSION_TOKEN is globally unique.
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
PROMPT Adding UK_APP_SESSION_TOKEN
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'UK_APP_SESSION_TOKEN'
       AND TABLE_NAME      = 'APP_SESSIONS'
       AND CONSTRAINT_TYPE = 'U';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
            ALTER TABLE APP_SESSIONS
            ADD CONSTRAINT UK_APP_SESSION_TOKEN
            UNIQUE (SESSION_TOKEN)
                        USING INDEX TABLESPACE APEXONE_INDEX
        ]';

        DBMS_OUTPUT.PUT_LINE('UK_APP_SESSION_TOKEN created.');

    ELSE

        DBMS_OUTPUT.PUT_LINE('UK_APP_SESSION_TOKEN already exists.');

    END IF;

END;
/

COMMIT;

PROMPT Completed.
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : PK_APP_SESSIONS
-- Object Type    : PRIMARY KEY CONSTRAINT
-- File           : app_sessions_pk.sql
-- Path           : database/modules/identity/constraints/app_sessions_pk.sql
-- Schema         : APEXONE
-- Version        : 1.5.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- -----------------------------------------------------------------------------
-- Description    : Primary key constraint for APP_SESSIONS.
-- =============================================================================

PROMPT Adding PK_APP_SESSIONS

DECLARE
    l_exists NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'PK_APP_SESSIONS'
       AND TABLE_NAME      = 'APP_SESSIONS'
       AND CONSTRAINT_TYPE = 'P';

    IF l_exists = 0 THEN
        EXECUTE IMMEDIATE '
            ALTER TABLE APP_SESSIONS
            ADD CONSTRAINT PK_APP_SESSIONS
            PRIMARY KEY (SESSION_ID)
                        USING INDEX TABLESPACE APEXONE_INDEX
        ';
    END IF;
END;
/

COMMIT;
PROMPT Completed.
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Indexes
-- Object Name    : IDX_APP_USERS_STATUS
-- Object Type    : INDEX
-- File           : IDX_APP_USERS_STATUS.sql
-- Path           : database\modules\identity\indexes\IDX_APP_USERS_STATUS.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- -----------------------------------------------------------------------------
-- Description    : Index for account status filtering.
-- =============================================================================
PROMPT Checking IDX_APP_USERS_STATUS

DECLARE
    l_exists PLS_INTEGER;
BEGIN
    SELECT COUNT(*)
      INTO l_exists
      FROM USER_INDEXES
     WHERE INDEX_NAME = UPPER('IDX_APP_USERS_STATUS');

    IF l_exists = 0 THEN
        EXECUTE IMMEDIATE 'CREATE INDEX IDX_APP_USERS_STATUS ON APP_USERS (ACCOUNT_STATUS_CODE) TABLESPACE APEXONE_INDEX';
        DBMS_OUTPUT.PUT_LINE('IDX_APP_USERS_STATUS : CREATED');
    ELSE
        DBMS_OUTPUT.PUT_LINE('IDX_APP_USERS_STATUS : EXISTS - SKIPPED');
    END IF;
END;
/

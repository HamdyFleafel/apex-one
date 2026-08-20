-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity Framework
-- Component      : User Management
-- Object Name    : APP_USERS
-- Object Type    : TABLE
-- File           : app_users.sql
-- Schema         : APEXONE
-- Description    : Stores application users.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.3
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating TABLE APP_USERS
PROMPT ============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK ON

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
    INTO l_exists
    FROM USER_TABLES
    WHERE TABLE_NAME = 'APP_USERS';


    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
            CREATE TABLE APP_USERS
            (
                USER_ID NUMBER(19) NOT NULL,
                USERNAME VARCHAR2(100 CHAR) NOT NULL,
                EMAIL VARCHAR2(320 CHAR) NOT NULL,
                DISPLAY_NAME VARCHAR2(200 CHAR),
                PASSWORD_VERIFIER VARCHAR2(500 CHAR),
                ACCOUNT_STATUS_CODE VARCHAR2(30 CHAR)
                    DEFAULT 'ACTIVE'
                    NOT NULL,
                FAILED_LOGIN_COUNT NUMBER DEFAULT 0,
                LOCKED_UNTIL TIMESTAMP WITH LOCAL TIME ZONE,
                LAST_LOGIN_AT TIMESTAMP WITH LOCAL TIME ZONE,
                CREATED_AT TIMESTAMP WITH LOCAL TIME ZONE
                    DEFAULT SYSTIMESTAMP
                    NOT NULL,
                CREATED_BY VARCHAR2(128 CHAR),
                UPDATED_AT TIMESTAMP WITH LOCAL TIME ZONE,
                UPDATED_BY VARCHAR2(128 CHAR),

                CONSTRAINT PK_APP_USERS
                    PRIMARY KEY(USER_ID)
            )
                           TABLESPACE APEXONE_DATA
        ]';


        DBMS_OUTPUT.PUT_LINE(
            'APP_USERS created.'
        );


    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'APP_USERS already exists.'
        );


    END IF;


END;
/

COMMENT ON TABLE APP_USERS
IS 'Application users master table.';


COMMENT ON COLUMN APP_USERS.USER_ID
IS 'Primary identifier.';


COMMENT ON COLUMN APP_USERS.USERNAME
IS 'Unique login name.';


COMMENT ON COLUMN APP_USERS.EMAIL
IS 'User email address.';


COMMENT ON COLUMN APP_USERS.ACCOUNT_STATUS_CODE
IS 'Account lifecycle status.';


COMMIT;


PROMPT Completed.
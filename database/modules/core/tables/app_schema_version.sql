-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Deployment Framework
-- Component      : Database Versioning
-- Object Name    : APP_SCHEMA_VERSION
-- Object Type    : TABLE
-- File           : app_schema_version.sql
-- Schema         : APEXONE
-- Description    : Stores executed database migration history.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.3
-- Database       : Oracle AI Database 26ai
-- =============================================================================


PROMPT ============================================================================
PROMPT Creating APP_SCHEMA_VERSION
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
    WHERE TABLE_NAME = 'APP_SCHEMA_VERSION';


    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
            CREATE TABLE APP_SCHEMA_VERSION
            (
                VERSION_NO         VARCHAR2(30 CHAR) NOT NULL,
                SCRIPT_NAME        VARCHAR2(255 CHAR) NOT NULL,
                DESCRIPTION        VARCHAR2(500 CHAR),
                INSTALLED_BY       VARCHAR2(128 CHAR)
                                   DEFAULT USER NOT NULL,
                INSTALLED_AT       TIMESTAMP WITH LOCAL TIME ZONE
                                   DEFAULT SYSTIMESTAMP NOT NULL,
                EXECUTION_TIME_MS  NUMBER(10),
                STATUS             VARCHAR2(20 CHAR) NOT NULL,
                CHECKSUM           VARCHAR2(64 CHAR),

                CONSTRAINT PK_APP_SCHEMA_VERSION
                    PRIMARY KEY (VERSION_NO),

                CONSTRAINT CHK_APP_SCHEMA_VERSION_STATUS
                    CHECK
                    (
                        STATUS IN
                        (
                            'RUNNING',
                            'SUCCESS',
                            'FAILED'
                        )
                    )
            )
                  TABLESPACE APEXONE_DATA
        ]';


        DBMS_OUTPUT.PUT_LINE(
            'APP_SCHEMA_VERSION created.'
        );


    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'APP_SCHEMA_VERSION already exists.'
        );


    END IF;


END;
/

COMMENT ON TABLE APP_SCHEMA_VERSION
IS 'Database migration history.';


COMMENT ON COLUMN APP_SCHEMA_VERSION.VERSION_NO
IS 'Migration version.';


COMMENT ON COLUMN APP_SCHEMA_VERSION.SCRIPT_NAME
IS 'Migration script name.';


COMMENT ON COLUMN APP_SCHEMA_VERSION.DESCRIPTION
IS 'Migration description.';


COMMENT ON COLUMN APP_SCHEMA_VERSION.INSTALLED_BY
IS 'Database user.';


COMMENT ON COLUMN APP_SCHEMA_VERSION.INSTALLED_AT
IS 'Execution timestamp.';


COMMENT ON COLUMN APP_SCHEMA_VERSION.EXECUTION_TIME_MS
IS 'Execution duration in milliseconds.';


COMMENT ON COLUMN APP_SCHEMA_VERSION.STATUS
IS 'Migration status.';


COMMENT ON COLUMN APP_SCHEMA_VERSION.CHECKSUM
IS 'Migration checksum.';



DECLARE
    l_exists NUMBER;

BEGIN

    SELECT COUNT(*)
    INTO l_exists
    FROM USER_INDEXES
    WHERE INDEX_NAME = 'IDX_APP_SCHEMA_VERSION_STATUS';


    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE
        '
        CREATE INDEX IDX_APP_SCHEMA_VERSION_STATUS
        ON APP_SCHEMA_VERSION (STATUS)
        TABLESPACE APEXONE_INDEX
        ';

        DBMS_OUTPUT.PUT_LINE(
            'IDX_APP_SCHEMA_VERSION_STATUS created.'
        );

    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'IDX_APP_SCHEMA_VERSION_STATUS already exists.'
        );

    END IF;


END;
/




DECLARE
    l_exists NUMBER;

BEGIN

    SELECT COUNT(*)
    INTO l_exists
    FROM USER_INDEXES
    WHERE INDEX_NAME = 'IDX_APP_SCHEMA_VERSION_DATE';


    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE
        '
        CREATE INDEX IDX_APP_SCHEMA_VERSION_DATE
        ON APP_SCHEMA_VERSION (INSTALLED_AT)
        TABLESPACE APEXONE_INDEX
        ';


        DBMS_OUTPUT.PUT_LINE(
            'IDX_APP_SCHEMA_VERSION_DATE created.'
        );


    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'IDX_APP_SCHEMA_VERSION_DATE already exists.'
        );


    END IF;


END;
/


COMMIT;


PROMPT Completed.

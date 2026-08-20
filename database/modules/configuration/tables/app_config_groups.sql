-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Configuration Framework
-- Component      : Tables
-- Object Name    : APP_CONFIG_GROUPS
-- Object Type    : TABLE
-- File           : app_config_groups.sql
-- Schema         : APEXONE
-- Description    : Stores configuration groups.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.3
-- =============================================================================


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
    WHERE TABLE_NAME = 'APP_CONFIG_GROUPS';


    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
            CREATE TABLE APP_CONFIG_GROUPS
            (
                GROUP_CODE     VARCHAR2(100 CHAR) NOT NULL,

                GROUP_NAME     VARCHAR2(200 CHAR) NOT NULL,

                DESCRIPTION    VARCHAR2(500 CHAR),

                CREATED_DATE   TIMESTAMP
                    DEFAULT SYSTIMESTAMP
                    NOT NULL
            )
            TABLESPACE APEXONE_DATA
        ]';


        DBMS_OUTPUT.PUT_LINE(
            'APP_CONFIG_GROUPS created.'
        );


    ELSE


        DBMS_OUTPUT.PUT_LINE(
            'APP_CONFIG_GROUPS already exists.'
        );


    END IF;


END;
/
    

COMMENT ON TABLE APP_CONFIG_GROUPS IS
'Stores configuration groups.';


COMMENT ON COLUMN APP_CONFIG_GROUPS.GROUP_CODE IS
'Configuration group code.';


COMMENT ON COLUMN APP_CONFIG_GROUPS.GROUP_NAME IS
'Configuration group name.';


COMMENT ON COLUMN APP_CONFIG_GROUPS.DESCRIPTION IS
'Configuration group description.';


COMMENT ON COLUMN APP_CONFIG_GROUPS.CREATED_DATE IS
'Creation timestamp.';


COMMIT;


PROMPT Completed.

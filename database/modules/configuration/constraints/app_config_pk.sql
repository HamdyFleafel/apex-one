-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Configuration Framework
-- Component      : Constraints
-- Object Name    : APP_CONFIG_PK
-- Object Type    : PRIMARY KEY
-- File           : app_config_pk.sql
-- Schema         : APEXONE
-- Description    : Creates primary key on APP_CONFIG.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.3
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating PRIMARY KEY APP_CONFIG_PK
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
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME='APP_CONFIG_PK'
       AND CONSTRAINT_TYPE='P';

    IF l_exists=0 THEN

        EXECUTE IMMEDIATE q'[
ALTER TABLE APP_CONFIG
ADD CONSTRAINT APP_CONFIG_PK
PRIMARY KEY (CONFIG_ID)
USING INDEX TABLESPACE APEXONE_INDEX
]';

        DBMS_OUTPUT.PUT_LINE('APP_CONFIG_PK created.');

    ELSE

        DBMS_OUTPUT.PUT_LINE('APP_CONFIG_PK already exists.');

    END IF;

END;
/

COMMIT;

PROMPT Completed.
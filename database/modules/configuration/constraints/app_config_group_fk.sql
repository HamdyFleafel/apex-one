-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Configuration Framework
-- Component      : Constraints
-- Object Name    : APP_CONFIG_GROUP_FK
-- Object Type    : FOREIGN KEY
-- File           : app_config_group_fk.sql
-- Schema         : APEXONE
-- Description    : Creates foreign key from APP_CONFIG to APP_CONFIG_GROUPS.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.3
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating FOREIGN KEY APP_CONFIG_GROUP_FK
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
     WHERE CONSTRAINT_NAME='APP_CONFIG_GROUP_FK'
       AND CONSTRAINT_TYPE='R';

    IF l_exists=0 THEN

        EXECUTE IMMEDIATE q'[
ALTER TABLE APP_CONFIG
ADD CONSTRAINT APP_CONFIG_GROUP_FK
FOREIGN KEY (CONFIG_GROUP)
REFERENCES APP_CONFIG_GROUPS (GROUP_CODE)
]';

        DBMS_OUTPUT.PUT_LINE('APP_CONFIG_GROUP_FK created.');

    ELSE

        DBMS_OUTPUT.PUT_LINE('APP_CONFIG_GROUP_FK already exists.');

    END IF;

END;
/

COMMIT;

PROMPT Completed.
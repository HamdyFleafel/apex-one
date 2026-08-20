-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Configuration Framework
-- Component      : Constraints
-- Object Name    : APP_CONFIG_KEY_UK
-- Object Type    : UNIQUE CONSTRAINT
-- File           : app_config_key_uk.sql
-- Schema         : APEXONE
-- Description    : Creates unique constraint on APP_CONFIG.CONFIG_KEY.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.3
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating UNIQUE Constraint APP_CONFIG_KEY_UK
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
     WHERE CONSTRAINT_NAME='APP_CONFIG_KEY_UK'
       AND CONSTRAINT_TYPE='U';

    IF l_exists=0 THEN

        EXECUTE IMMEDIATE q'[
ALTER TABLE APP_CONFIG
ADD CONSTRAINT APP_CONFIG_KEY_UK
UNIQUE (CONFIG_KEY)
USING INDEX TABLESPACE APEXONE_INDEX
]';

        DBMS_OUTPUT.PUT_LINE('APP_CONFIG_KEY_UK created.');

    ELSE

        DBMS_OUTPUT.PUT_LINE('APP_CONFIG_KEY_UK already exists.');

    END IF;

END;
/

COMMIT;

PROMPT Completed.
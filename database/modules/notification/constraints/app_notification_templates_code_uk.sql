-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Notification Framework
-- Component      : Constraints
-- Object Name    : APP_NOTIFICATION_TEMPLATES_CODE_UK
-- Object Type    : UNIQUE CONSTRAINT
-- File           : app_notification_templates_code_uk.sql
-- Schema         : APEXONE
-- Description    : Creates unique constraint on TEMPLATE_CODE.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.4
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating UNIQUE Constraint APP_NOTIFICATION_TEMPLATES_CODE_UK
PROMPT ============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME='APP_NOTIFICATION_TEMPLATES_CODE_UK'
       AND CONSTRAINT_TYPE='U';

    IF l_exists=0 THEN

        EXECUTE IMMEDIATE q'[
ALTER TABLE APP_NOTIFICATION_TEMPLATES
ADD CONSTRAINT APP_NOTIFICATION_TEMPLATES_CODE_UK
UNIQUE (TEMPLATE_CODE)
USING INDEX TABLESPACE APEXONE_INDEX
]';

        DBMS_OUTPUT.PUT_LINE('APP_NOTIFICATION_TEMPLATES_CODE_UK created.');

    ELSE

        DBMS_OUTPUT.PUT_LINE('APP_NOTIFICATION_TEMPLATES_CODE_UK already exists.');

    END IF;

END;
/

COMMIT;

PROMPT Completed.
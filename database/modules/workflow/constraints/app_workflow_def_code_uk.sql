-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Workflow Framework
-- Component      : Constraints
-- Object Name    : APP_WORKFLOW_DEF_CODE_UK
-- Object Type    : UNIQUE CONSTRAINT
-- File           : app_workflow_def_code_uk.sql
-- Schema         : APEXONE
-- Description    : Creates unique constraint on WORKFLOW_CODE.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.4
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating UNIQUE Constraint APP_WORKFLOW_DEF_CODE_UK
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
     WHERE CONSTRAINT_NAME = 'APP_WORKFLOW_DEF_CODE_UK';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
ALTER TABLE APP_WORKFLOW_DEFINITIONS
ADD CONSTRAINT APP_WORKFLOW_DEF_CODE_UK
UNIQUE (WORKFLOW_CODE)
USING INDEX TABLESPACE APEXONE_INDEX
]';

        DBMS_OUTPUT.PUT_LINE('APP_WORKFLOW_DEF_CODE_UK created.');

    ELSE

        DBMS_OUTPUT.PUT_LINE('APP_WORKFLOW_DEF_CODE_UK already exists.');

    END IF;

END;
/

COMMIT;

PROMPT Completed.
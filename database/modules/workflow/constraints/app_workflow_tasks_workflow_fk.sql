-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Workflow Framework
-- Component      : Constraints
-- Object Name    : APP_WORKFLOW_TASKS_WORKFLOW_FK
-- Object Type    : FOREIGN KEY
-- File           : app_workflow_tasks_workflow_fk.sql
-- Schema         : APEXONE
-- Description    : Creates foreign key from APP_WORKFLOW_TASKS to APP_WORKFLOW_DEFINITIONS.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.4
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating FOREIGN KEY APP_WORKFLOW_TASKS_WORKFLOW_FK
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
     WHERE CONSTRAINT_NAME = 'APP_WORKFLOW_TASKS_WORKFLOW_FK';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE q'[
ALTER TABLE APP_WORKFLOW_TASKS
ADD CONSTRAINT APP_WORKFLOW_TASKS_WORKFLOW_FK
FOREIGN KEY (WORKFLOW_ID)
REFERENCES APP_WORKFLOW_DEFINITIONS (WORKFLOW_ID)
]';

        DBMS_OUTPUT.PUT_LINE('APP_WORKFLOW_TASKS_WORKFLOW_FK created.');

    ELSE

        DBMS_OUTPUT.PUT_LINE('APP_WORKFLOW_TASKS_WORKFLOW_FK already exists.');

    END IF;

END;
/

COMMIT;

PROMPT Completed.
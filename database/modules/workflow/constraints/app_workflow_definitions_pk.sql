-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Workflow Framework
-- Component      : Constraints
-- Object Name    : APP_WORKFLOW_DEFINITIONS_PK
-- Object Type    : PRIMARY KEY
-- File           : app_workflow_definitions_pk.sql
-- Schema         : APEXONE
-- Description    : Creates primary key for APP_WORKFLOW_DEFINITIONS.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.4
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating PRIMARY KEY APP_WORKFLOW_DEFINITIONS_PK
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
     WHERE CONSTRAINT_NAME='APP_WORKFLOW_DEFINITIONS_PK';

    IF l_exists=0 THEN

        EXECUTE IMMEDIATE q'[
ALTER TABLE APP_WORKFLOW_DEFINITIONS
ADD CONSTRAINT APP_WORKFLOW_DEFINITIONS_PK
PRIMARY KEY (WORKFLOW_ID)
USING INDEX TABLESPACE APEXONE_INDEX
]';

        DBMS_OUTPUT.PUT_LINE('APP_WORKFLOW_DEFINITIONS_PK created.');

    ELSE

        DBMS_OUTPUT.PUT_LINE('APP_WORKFLOW_DEFINITIONS_PK already exists.');

    END IF;

END;
/

COMMIT;

PROMPT Completed.
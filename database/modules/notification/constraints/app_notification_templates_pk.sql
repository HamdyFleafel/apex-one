/*====================================================================
  APEXONE Enterprise Platform

  File Name    : app_notification_templates_pk.sql
  Module       : Notification Framework
  Object Type  : CONSTRAINT
  Object Name  : APP_NOTIFICATION_TEMPLATES_PK

  Purpose:
  Creates primary key on APP_NOTIFICATION_TEMPLATES.

  Version      : 1.0.0-alpha.4
====================================================================*/

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF

PROMPT ============================================================================
PROMPT Creating PRIMARY KEY APP_NOTIFICATION_TEMPLATES_PK
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO l_exists
    FROM user_constraints
    WHERE constraint_name='APP_NOTIFICATION_TEMPLATES_PK'
      AND constraint_type='P';

    IF l_exists=0 THEN
        EXECUTE IMMEDIATE q'[
            ALTER TABLE app_notification_templates
            ADD CONSTRAINT app_notification_templates_pk
            PRIMARY KEY(template_id)
                        USING INDEX TABLESPACE APEXONE_INDEX
        ]';

        DBMS_OUTPUT.PUT_LINE('APP_NOTIFICATION_TEMPLATES_PK created.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('APP_NOTIFICATION_TEMPLATES_PK already exists.');
    END IF;
END;
/

COMMIT;

PROMPT Completed.
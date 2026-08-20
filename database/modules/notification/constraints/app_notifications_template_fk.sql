-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Notification Framework
-- Component      : Constraints
-- Object Name    : APP_NOTIFICATIONS_TEMPLATE_FK
-- Object Type    : FOREIGN KEY
-- File           : app_notifications_template_fk.sql
-- Schema         : APEXONE
-- Description    : Creates foreign key from APP_NOTIFICATIONS to APP_NOTIFICATION_TEMPLATES.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.4
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating FOREIGN KEY APP_NOTIFICATIONS_TEMPLATE_FK
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
     WHERE CONSTRAINT_NAME='APP_NOTIFICATIONS_TEMPLATE_FK'
       AND CONSTRAINT_TYPE='R';

    IF l_exists=0 THEN

        EXECUTE IMMEDIATE q'[
ALTER TABLE APP_NOTIFICATIONS
ADD CONSTRAINT APP_NOTIFICATIONS_TEMPLATE_FK
FOREIGN KEY (TEMPLATE_ID)
REFERENCES APP_NOTIFICATION_TEMPLATES (TEMPLATE_ID)
]';

        DBMS_OUTPUT.PUT_LINE('APP_NOTIFICATIONS_TEMPLATE_FK created.');

    ELSE

        DBMS_OUTPUT.PUT_LINE('APP_NOTIFICATIONS_TEMPLATE_FK already exists.');

    END IF;

END;
/

COMMIT;

PROMPT Completed.
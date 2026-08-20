-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Notification Framework
-- Component      : Constraints
-- Object Name    : APP_NOTIFICATIONS_PK
-- Object Type    : PRIMARY KEY
-- File           : app_notifications_pk.sql
-- Schema         : APEXONE
-- Description    : Creates primary key on APP_NOTIFICATIONS.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.4
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating PRIMARY KEY APP_NOTIFICATIONS_PK
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
     WHERE CONSTRAINT_NAME='APP_NOTIFICATIONS_PK'
       AND CONSTRAINT_TYPE='P';

    IF l_exists=0 THEN

        EXECUTE IMMEDIATE q'[
ALTER TABLE APP_NOTIFICATIONS
ADD CONSTRAINT APP_NOTIFICATIONS_PK
PRIMARY KEY (NOTIFICATION_ID)
USING INDEX TABLESPACE APEXONE_INDEX
]';

        DBMS_OUTPUT.PUT_LINE('APP_NOTIFICATIONS_PK created.');

    ELSE

        DBMS_OUTPUT.PUT_LINE('APP_NOTIFICATIONS_PK already exists.');

    END IF;

END;
/

COMMIT;

PROMPT Completed.
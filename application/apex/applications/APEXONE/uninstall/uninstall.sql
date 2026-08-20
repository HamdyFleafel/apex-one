-- APEXONE APEX Application Uninstallation Contract
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT === APEXONE APEX APPLICATION UNINSTALL ===

DECLARE
    l_app_id NUMBER;
BEGIN
    SELECT application_id
      INTO l_app_id
      FROM apex_applications
     WHERE alias = 'APEXONE';

    apex_application_install.remove_application(p_application_id => l_app_id);
    DBMS_OUTPUT.PUT_LINE('APEXONE application removed: ' || l_app_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('APEXONE application is not installed.');
END;
/

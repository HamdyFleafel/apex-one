-- APEXONE APEX Application Installation Contract
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT === APEXONE APEX APPLICATION INSTALL ===
PROMPT Canonical source: application/apex/applications/APEXONE/export/

-- The real APEX export is intentionally absent until the application ID is assigned
-- and the first authoritative export is generated from the target APEX instance.
-- Do not replace this contract with a hand-written second implementation.

DECLARE
    l_app_id NUMBER;
BEGIN
    SELECT application_id
      INTO l_app_id
      FROM apex_applications
     WHERE alias = 'APEXONE';

    DBMS_OUTPUT.PUT_LINE('APEXONE application already exists: ' || l_app_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20990,
            'APEXONE application export is not yet assigned/generated. Generate the authoritative export before installation.');
END;
/

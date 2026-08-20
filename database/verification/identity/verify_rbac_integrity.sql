-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Verification
-- Object Name    : VERIFY_RBAC_INTEGRITY
-- Object Type    : SCRIPT
-- =============================================================================

PROMPT Verifying RBAC integrity...

SET SERVEROUTPUT ON

DECLARE
    l_orphans NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_orphans
      FROM APP_ROLE_PERMISSIONS rp
      WHERE NOT EXISTS
        (SELECT 1 FROM APP_ROLES r WHERE r.ROLE_ID = rp.ROLE_ID);

    IF l_orphans > 0 THEN
        RAISE_APPLICATION_ERROR(-21003,'Orphan role-permission records found.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('RBAC integrity verified.');

END;
/

PROMPT RBAC verification completed.
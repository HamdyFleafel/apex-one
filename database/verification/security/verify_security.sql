-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Verification
-- Object Name    : VERIFY_SECURITY
-- Object Type    : SCRIPT
-- File           : verify_security.sql
-- Path           : database/verification/security/verify_security.sql
-- Schema         : APEXONE
-- Version        : 1.9.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- -----------------------------------------------------------------------------
-- Description    : Verifies Security module structural integrity.
-- =============================================================================

PROMPT ============================================================================
PROMPT Verifying Security Module
PROMPT ============================================================================

SET SERVEROUTPUT ON

DECLARE
    l_count NUMBER;
BEGIN

    SELECT COUNT(*) INTO l_count FROM USER_TABLES
     WHERE TABLE_NAME IN
     ('APP_SESSIONS','APP_LOGIN_ATTEMPTS','APP_LOGIN_HISTORY',
      'APP_PASSWORD_HISTORY');

    IF l_count <> 4 THEN
        RAISE_APPLICATION_ERROR(-20002,'Security tables missing.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Security tables verified.');

END;
/

PROMPT Security verification completed.
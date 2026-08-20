-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Integration
-- Component      : Structural Verification
-- Object Name    : VERIFY_INTEGRATION
-- Object Type    : SCRIPT
-- File           : verify_integration.sql
-- Path           : database/verification/integration/verify_integration.sql
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT ============================================================================
PROMPT Verifying Integration Module
PROMPT ============================================================================

DECLARE
    PROCEDURE assert_valid
    (
        p_name IN VARCHAR2,
        p_type IN VARCHAR2
    )
    IS
        l_status user_objects.status%TYPE;
    BEGIN
        SELECT status
          INTO l_status
          FROM user_objects
         WHERE object_name = p_name
           AND object_type = p_type;

        IF l_status <> 'VALID' THEN
            RAISE_APPLICATION_ERROR(
                -20000,
                'FAIL - ' || p_name || ' ' || p_type || ' is ' || l_status
            );
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            'PASS - ' || p_name || ' ' || p_type || ' is VALID'
        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20000,
                'FAIL - ' || p_name || ' ' || p_type || ' does not exist'
            );
    END assert_valid;
BEGIN
    assert_valid('PKG_INTEGRATION', 'PACKAGE');
    assert_valid('PKG_INTEGRATION', 'PACKAGE BODY');

    assert_valid('PKG_IDENTITY', 'PACKAGE');
    assert_valid('PKG_IDENTITY', 'PACKAGE BODY');

    assert_valid('PKG_ERRORS', 'PACKAGE');
    assert_valid('PKG_ERRORS', 'PACKAGE BODY');
END;
/

PROMPT Integration structural verification completed successfully.

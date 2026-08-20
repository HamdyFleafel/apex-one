-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Authentication Tests
-- Object Name    : TEST_AUTHENTICATION_LOCKOUT
-- Object Type    : TEST SCRIPT
-- File           : TEST_AUTHENTICATION_LOCKOUT.sql
-- Path           : database/modules/security/tests/TEST_AUTHENTICATION_LOCKOUT.sql
-- Schema         : APEXONE
-- Version        : 2.1.0-alpha.2
-- Status         : Development
-- =============================================================================
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : [hamdy.fleafel@belcofarms.com]
-- WhatsApp       : 0020 1010506080
--
-- Description    : Deterministic authentication lockout test.
--                  Verifies that failed authentication attempts increment
--                  FAILED_LOGIN_COUNT and that the fifth failed attempt
--                  causes a temporary account lock.
--
--                  PKG_AUTHENTICATION.LOGIN is a FUNCTION returning NUMBER.
--                  Therefore every invocation captures the returned USER_ID.
--
-- Expected policy:
--                  Attempt 1 -> FAILED_LOGIN_COUNT = 1
--                  Attempt 2 -> FAILED_LOGIN_COUNT = 2
--                  Attempt 3 -> FAILED_LOGIN_COUNT = 3
--                  Attempt 4 -> FAILED_LOGIN_COUNT = 4
--                  Attempt 5 -> FAILED_LOGIN_COUNT = 5 + LOCKED_UNTIL
--
-- Test account:
--                  USER_ID  = 101
--                  USERNAME = TEST_SECURITY_USER
--
-- IMPORTANT:
--                  The password used below is intentionally WRONG.
--                  This script tests authentication failure and lockout,
--                  not successful password authentication.
-- =============================================================================

SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK ON
SET HEADING ON

PROMPT
PROMPT ============================================================================
PROMPT TEST 01 - INITIAL ACCOUNT SECURITY STATE
PROMPT ============================================================================
PROMPT

SELECT
    USER_ID,
    USERNAME,
    ACCOUNT_STATUS_CODE,
    FAILED_LOGIN_COUNT,
    LOCKED_UNTIL,
    FORCE_PASSWORD_RESET,
    PASSWORD_EXPIRES_AT
FROM APP_USERS
WHERE USER_ID = 101;

PROMPT
PROMPT ============================================================================
PROMPT TEST 02 - RESET TEST ACCOUNT FAILURE STATE
PROMPT ============================================================================
PROMPT This prepares USER_ID 101 for a deterministic lockout test.
PROMPT ============================================================================

UPDATE APP_USERS
   SET FAILED_LOGIN_COUNT = 0,
       LOCKED_UNTIL       = NULL
 WHERE USER_ID = 101;

COMMIT;

SELECT
    USER_ID,
    USERNAME,
    FAILED_LOGIN_COUNT,
    LOCKED_UNTIL
FROM APP_USERS
WHERE USER_ID = 101;

PROMPT
PROMPT ============================================================================
PROMPT TEST 03 - FAILED LOGIN ATTEMPT #1
PROMPT ============================================================================
PROMPT

DECLARE
    L_RESULT NUMBER;
BEGIN

    L_RESULT := PKG_AUTHENTICATION.LOGIN(
        P_USERNAME   => 'TEST_SECURITY_USER',
        P_PASSWORD   => 'DefinitelyWrongPassword!1',
        P_IP_ADDRESS => '127.0.0.1',
        P_USER_AGENT => 'APEXONE-LOCKOUT-TEST'
    );

    DBMS_OUTPUT.PUT_LINE(
        'UNEXPECTED: ATTEMPT #1 WAS ACCEPTED. RETURNED USER_ID = ' ||
        L_RESULT
    );

EXCEPTION
    WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE(
            'EXPECTED FAILURE #1: ' ||
            SQLCODE || ' - ' || SQLERRM
        );

END;
/

SELECT
    USER_ID,
    FAILED_LOGIN_COUNT,
    LOCKED_UNTIL
FROM APP_USERS
WHERE USER_ID = 101;

PROMPT
PROMPT ============================================================================
PROMPT TEST 04 - FAILED LOGIN ATTEMPT #2
PROMPT ============================================================================

DECLARE
    L_RESULT NUMBER;
BEGIN

    L_RESULT := PKG_AUTHENTICATION.LOGIN(
        P_USERNAME   => 'TEST_SECURITY_USER',
        P_PASSWORD   => 'DefinitelyWrongPassword!1',
        P_IP_ADDRESS => '127.0.0.1',
        P_USER_AGENT => 'APEXONE-LOCKOUT-TEST'
    );

    DBMS_OUTPUT.PUT_LINE(
        'UNEXPECTED: ATTEMPT #2 WAS ACCEPTED. RETURNED USER_ID = ' ||
        L_RESULT
    );

EXCEPTION
    WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE(
            'EXPECTED FAILURE #2: ' ||
            SQLCODE || ' - ' || SQLERRM
        );

END;
/

SELECT
    USER_ID,
    FAILED_LOGIN_COUNT,
    LOCKED_UNTIL
FROM APP_USERS
WHERE USER_ID = 101;

PROMPT
PROMPT ============================================================================
PROMPT TEST 05 - FAILED LOGIN ATTEMPT #3
PROMPT ============================================================================

DECLARE
    L_RESULT NUMBER;
BEGIN

    L_RESULT := PKG_AUTHENTICATION.LOGIN(
        P_USERNAME   => 'TEST_SECURITY_USER',
        P_PASSWORD   => 'DefinitelyWrongPassword!1',
        P_IP_ADDRESS => '127.0.0.1',
        P_USER_AGENT => 'APEXONE-LOCKOUT-TEST'
    );

    DBMS_OUTPUT.PUT_LINE(
        'UNEXPECTED: ATTEMPT #3 WAS ACCEPTED. RETURNED USER_ID = ' ||
        L_RESULT
    );

EXCEPTION
    WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE(
            'EXPECTED FAILURE #3: ' ||
            SQLCODE || ' - ' || SQLERRM
        );

END;
/

SELECT
    USER_ID,
    FAILED_LOGIN_COUNT,
    LOCKED_UNTIL
FROM APP_USERS
WHERE USER_ID = 101;

PROMPT
PROMPT ============================================================================
PROMPT TEST 06 - FAILED LOGIN ATTEMPT #4
PROMPT ============================================================================

DECLARE
    L_RESULT NUMBER;
BEGIN

    L_RESULT := PKG_AUTHENTICATION.LOGIN(
        P_USERNAME   => 'TEST_SECURITY_USER',
        P_PASSWORD   => 'DefinitelyWrongPassword!1',
        P_IP_ADDRESS => '127.0.0.1',
        P_USER_AGENT => 'APEXONE-LOCKOUT-TEST'
    );

    DBMS_OUTPUT.PUT_LINE(
        'UNEXPECTED: ATTEMPT #4 WAS ACCEPTED. RETURNED USER_ID = ' ||
        L_RESULT
    );

EXCEPTION
    WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE(
            'EXPECTED FAILURE #4: ' ||
            SQLCODE || ' - ' || SQLERRM
        );

END;
/

SELECT
    USER_ID,
    FAILED_LOGIN_COUNT,
    LOCKED_UNTIL
FROM APP_USERS
WHERE USER_ID = 101;

PROMPT
PROMPT ============================================================================
PROMPT TEST 07 - FAILED LOGIN ATTEMPT #5
PROMPT ============================================================================
PROMPT This attempt must trigger the 15-minute account lock.
PROMPT ============================================================================

DECLARE
    L_RESULT NUMBER;
BEGIN

    L_RESULT := PKG_AUTHENTICATION.LOGIN(
        P_USERNAME   => 'TEST_SECURITY_USER',
        P_PASSWORD   => 'DefinitelyWrongPassword!1',
        P_IP_ADDRESS => '127.0.0.1',
        P_USER_AGENT => 'APEXONE-LOCKOUT-TEST'
    );

    DBMS_OUTPUT.PUT_LINE(
        'UNEXPECTED: ATTEMPT #5 WAS ACCEPTED. RETURNED USER_ID = ' ||
        L_RESULT
    );

EXCEPTION
    WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE(
            'EXPECTED LOCKOUT FAILURE: ' ||
            SQLCODE || ' - ' || SQLERRM
        );

END;
/

SELECT
    USER_ID,
    USERNAME,
    FAILED_LOGIN_COUNT,
    LOCKED_UNTIL,
    SYSTIMESTAMP AS CURRENT_TIME
FROM APP_USERS
WHERE USER_ID = 101;

PROMPT
PROMPT ============================================================================
PROMPT TEST 08 - VERIFY LOCKOUT STATE
PROMPT ============================================================================

SELECT
    USER_ID,
    USERNAME,
    FAILED_LOGIN_COUNT,
    LOCKED_UNTIL,
    SYSTIMESTAMP AS CURRENT_TIME,
    CASE
        WHEN LOCKED_UNTIL IS NOT NULL
         AND LOCKED_UNTIL > SYSTIMESTAMP
        THEN ROUND(
                 EXTRACT(
                     DAY FROM
                     (CAST(LOCKED_UNTIL AS TIMESTAMP) - SYSTIMESTAMP)
                 ) * 24 * 60
                 +
                 EXTRACT(
                     HOUR FROM
                     (CAST(LOCKED_UNTIL AS TIMESTAMP) - SYSTIMESTAMP)
                 ) * 60
                 +
                 EXTRACT(
                     MINUTE FROM
                     (CAST(LOCKED_UNTIL AS TIMESTAMP) - SYSTIMESTAMP)
                 ),
                 2
             )
        ELSE 0
    END AS MINUTES_REMAINING
FROM APP_USERS
WHERE USER_ID = 101;

PROMPT
PROMPT ============================================================================
PROMPT TEST 09 - EXPECTED FINAL STATE
PROMPT ============================================================================
PROMPT FAILED_LOGIN_COUNT = 5
PROMPT LOCKED_UNTIL       > CURRENT_TIME
PROMPT FORCE_PASSWORD_RESET = N
PROMPT ACCOUNT_STATUS_CODE  = ACTIVE
PROMPT ============================================================================

SELECT
    USER_ID,
    USERNAME,
    FAILED_LOGIN_COUNT,
    LOCKED_UNTIL,
    FORCE_PASSWORD_RESET,
    ACCOUNT_STATUS_CODE,
    CASE
        WHEN FAILED_LOGIN_COUNT = 5
         AND LOCKED_UNTIL IS NOT NULL
         AND LOCKED_UNTIL > SYSTIMESTAMP
         AND NVL(FORCE_PASSWORD_RESET, 'N') = 'N'
         AND ACCOUNT_STATUS_CODE = 'ACTIVE'
        THEN 'PASS'
        ELSE 'FAIL'
    END AS LOCKOUT_TEST_RESULT
FROM APP_USERS
WHERE USER_ID = 101;

PROMPT
PROMPT ============================================================================
PROMPT TEST 10 - LOGIN WHILE ACCOUNT IS LOCKED
PROMPT ============================================================================
PROMPT Correct password must be rejected while LOCKED_UNTIL is active.
PROMPT ============================================================================

DECLARE
    L_RESULT NUMBER;
BEGIN

    L_RESULT := PKG_AUTHENTICATION.LOGIN(
        P_USERNAME   => 'TEST_SECURITY_USER',
        P_PASSWORD   => 'DefinitelyWrongPassword!1',
        P_IP_ADDRESS => '127.0.0.1',
        P_USER_AGENT => 'APEXONE-LOCKOUT-TEST'
    );

    DBMS_OUTPUT.PUT_LINE(
        'UNEXPECTED: LOCKED ACCOUNT ACCEPTED LOGIN. RETURNED USER_ID = ' ||
        L_RESULT
    );

EXCEPTION
    WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE(
            'EXPECTED LOCKED-ACCOUNT FAILURE: ' ||
            SQLCODE || ' - ' || SQLERRM
        );

END;
/

PROMPT
PROMPT ============================================================================
PROMPT TEST 11 - FINAL ACCOUNT STATE
PROMPT ============================================================================

SELECT
    USER_ID,
    USERNAME,
    ACCOUNT_STATUS_CODE,
    FAILED_LOGIN_COUNT,
    LOCKED_UNTIL,
    FORCE_PASSWORD_RESET,
    SYSTIMESTAMP AS CURRENT_TIME
FROM APP_USERS
WHERE USER_ID = 101;

PROMPT
PROMPT ============================================================================
PROMPT TEST COMPLETE
PROMPT ============================================================================
PROMPT

-- =============================================================================
-- CLEANUP
-- =============================================================================
-- Restore the deterministic test account to an unlocked state.
-- =============================================================================

UPDATE APP_USERS
   SET FAILED_LOGIN_COUNT = 0,
       LOCKED_UNTIL       = NULL
 WHERE USER_ID = 101;

COMMIT;

PROMPT
PROMPT ============================================================================
PROMPT TEST ACCOUNT RESET COMPLETE
PROMPT ============================================================================
PROMPT
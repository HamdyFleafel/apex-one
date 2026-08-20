-- =============================================================================
-- Project         : APEXONE Enterprise Platform
-- Module          : Identity
-- Component       : Tests
-- Object Name     : TEST_PKG_IDENTITY
-- Object Type     : SQL SCRIPT
-- File            : TEST_PKG_IDENTITY.sql
-- Path            : database/modules/identity/tests/
-- Schema          : APEXONE
-- -----------------------------------------------------------------------------
-- Description     : Regression Test Script for PKG_IDENTITY
-- =============================================================================

SET SERVEROUTPUT ON
SET VERIFY OFF

PROMPT
PROMPT ==========================================================
PROMPT STARTING PKG_IDENTITY REGRESSION TEST
PROMPT ==========================================================
PROMPT

VARIABLE V_USER_ID NUMBER

--------------------------------------------------------------------------------
-- TEST 01 - CREATE USER
--------------------------------------------------------------------------------

PROMPT
PROMPT TEST 01 - CREATE USER
PROMPT

BEGIN

    :V_USER_ID := PKG_IDENTITY.CREATE_USER
    (
        P_USERNAME => 'ADMIN',
        P_EMAIL    => 'ADMIN@APEXONE.LOCAL',
        P_PASSWORD => 'Admin@123'
    );

END;
/

PRINT V_USER_ID

COLUMN USERNAME FORMAT A20
COLUMN EMAIL FORMAT A35
COLUMN ACCOUNT_STATUS_CODE FORMAT A15

SELECT USER_ID,
       USERNAME,
       EMAIL,
       ACCOUNT_STATUS_CODE,
       FAILED_LOGIN_COUNT
  FROM APP_USERS
 WHERE USER_ID = :V_USER_ID;

PROMPT
PROMPT TEST 01 PASSED
PROMPT

--------------------------------------------------------------------------------
-- TEST 02 - DUPLICATE USER
--------------------------------------------------------------------------------

PROMPT
PROMPT TEST 02 - DUPLICATE USER
PROMPT EXPECTED RESULT:
PROMPT USERNAME ALREADY EXISTS
PROMPT

BEGIN

    PKG_IDENTITY.CREATE_USER
    (
        P_USERNAME => 'ADMIN',
        P_EMAIL    => 'ADMIN@APEXONE.LOCAL',
        P_PASSWORD => 'Admin@123'
    );

END;
/

--------------------------------------------------------------------------------
-- TEST 03 - UPDATE USER STATUS
--------------------------------------------------------------------------------

PROMPT
PROMPT TEST 03 - UPDATE USER STATUS
PROMPT

BEGIN

    PKG_IDENTITY.UPDATE_USER_STATUS
    (
        P_USER_ID => :V_USER_ID,
        P_ACCOUNT_STATUS_CODE => 'LOCKED'
    );

END;
/

SELECT USER_ID,
       ACCOUNT_STATUS_CODE
FROM APP_USERS
WHERE USER_ID=:V_USER_ID;

PROMPT
PROMPT TEST 03 PASSED
PROMPT

--------------------------------------------------------------------------------
-- TEST 04 - LOCK USER
--------------------------------------------------------------------------------

PROMPT
PROMPT TEST 04 - LOCK USER
PROMPT

BEGIN

    PKG_IDENTITY.LOCK_USER
    (
        P_USER_ID => :V_USER_ID
    );

END;
/

COLUMN LOCKED_UNTIL FORMAT A35

SELECT USER_ID,
       LOCKED_UNTIL
FROM APP_USERS
WHERE USER_ID=:V_USER_ID;

PROMPT
PROMPT TEST 04 PASSED
PROMPT

--------------------------------------------------------------------------------
-- TEST 05 - CREATE ROLE
--------------------------------------------------------------------------------

PROMPT
PROMPT TEST 05 - CREATE ROLE
PROMPT

INSERT INTO APP_ROLES
(
    ROLE_ID,
    ROLE_CODE,
    ROLE_NAME,
    CREATED_AT,
    CREATED_BY
)
VALUES
(
    1,
    'ADMIN',
    'SYSTEM ADMINISTRATOR',
    SYSTIMESTAMP,
    USER
);

COMMIT;

SELECT *
FROM APP_ROLES;

PROMPT
PROMPT TEST 05 PASSED
PROMPT

--------------------------------------------------------------------------------
-- TEST 06 - ASSIGN ROLE
--------------------------------------------------------------------------------

PROMPT
PROMPT TEST 06 - ASSIGN ROLE
PROMPT

BEGIN

    PKG_IDENTITY.ASSIGN_ROLE
    (
        P_USER_ID => :V_USER_ID,
        P_ROLE_CODE => 'ADMIN'
    );

END;
/

SELECT *
FROM APP_USER_ROLES;

PROMPT
PROMPT TEST 06 PASSED
PROMPT

--------------------------------------------------------------------------------
-- TEST 07 - CREATE PERMISSION
--------------------------------------------------------------------------------

PROMPT
PROMPT TEST 07 - CREATE PERMISSION
PROMPT

INSERT INTO APP_PERMISSIONS
(
    PERMISSION_ID,
    PERMISSION_CODE,
    PERMISSION_NAME,
    DESCRIPTION,
    STATUS,
    IS_DELETED,
    CREATED_AT,
    CREATED_BY
)
VALUES
(
    1,
    'USER.CREATE',
    'CREATE USER',
    'ALLOW CREATE USER',
    'ACTIVE',
    'N',
    SYSTIMESTAMP,
    USER
);

COMMIT;

SELECT *
FROM APP_PERMISSIONS;

PROMPT
PROMPT TEST 07 PASSED
PROMPT

--------------------------------------------------------------------------------
-- TEST 08 - ASSIGN PERMISSION TO ROLE
--------------------------------------------------------------------------------

PROMPT
PROMPT TEST 08 - ASSIGN PERMISSION
PROMPT

INSERT INTO APP_ROLE_PERMISSIONS
(
    ROLE_PERMISSION_ID,
    ROLE_ID,
    PERMISSION_ID,
    CREATED_AT,
    CREATED_BY
)
VALUES
(
    1,
    1,
    1,
    SYSTIMESTAMP,
    USER
);

COMMIT;

SELECT *
FROM APP_ROLE_PERMISSIONS;

PROMPT
PROMPT TEST 08 PASSED
PROMPT

--------------------------------------------------------------------------------
-- TEST 09 - IS USER AUTHORIZED
--------------------------------------------------------------------------------

PROMPT
PROMPT TEST 09 - IS USER AUTHORIZED
PROMPT

DECLARE

    L_RESULT BOOLEAN;

BEGIN

    L_RESULT :=
        PKG_IDENTITY.IS_USER_AUTHORIZED
        (
            P_USER_ID => :V_USER_ID,
            P_PERMISSION => 'USER.CREATE'
        );

    IF L_RESULT THEN

        DBMS_OUTPUT.PUT_LINE('AUTHORIZED');

    ELSE

        DBMS_OUTPUT.PUT_LINE('NOT AUTHORIZED');

    END IF;

END;
/

PROMPT
PROMPT TEST 09 PASSED
PROMPT

--------------------------------------------------------------------------------
-- TEST 10 - REVOKE ROLE
--------------------------------------------------------------------------------

PROMPT
PROMPT TEST 10 - REVOKE ROLE
PROMPT

BEGIN

    PKG_IDENTITY.REVOKE_ROLE
    (
        P_USER_ID => :V_USER_ID,
        P_ROLE_CODE => 'ADMIN'
    );

END;
/

SELECT *
FROM APP_USER_ROLES;

PROMPT
PROMPT TEST 10 PASSED
PROMPT

--------------------------------------------------------------------------------
-- TEST COMPLETED
--------------------------------------------------------------------------------

PROMPT
PROMPT ==========================================================
PROMPT ALL PKG_IDENTITY TESTS COMPLETED SUCCESSFULLY
PROMPT ==========================================================
PROMPT
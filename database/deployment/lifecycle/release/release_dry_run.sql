-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Lifecycle
-- Component      : Release Management
-- Object Name    : RELEASE_DRY_RUN
-- Object Type    : SCRIPT
-- File           : release_dry_run.sql
-- Path           : database/deployment/installment/lifecycle/release/release_dry_run.sql
-- Schema         : APEXONE
-- Version        : 2.3.0-alpha.2
-- Status         : Release Candidate
-- =============================================================================

PROMPT ============================================================================
PROMPT APEXONE Release Dry-Run
PROMPT ============================================================================
PROMPT No database changes will be performed.
PROMPT ============================================================================

WHENEVER SQLERROR EXIT FAILURE ROLLBACK

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET FEEDBACK ON
SET VERIFY OFF
SET HEADING OFF
SET SQLBLANKLINES ON

DECLARE
l_count    NUMBER;
l_failures NUMBER := 0;

PROCEDURE check_count(
    p_label  VARCHAR2,
    p_count  NUMBER,
    p_expect NUMBER
) IS
BEGIN
    IF p_count = p_expect THEN
        DBMS_OUTPUT.PUT_LINE(
            '[PASS] ' || p_label || ' = ' || p_count
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            '[FAIL] ' || p_label ||
            ' = ' || p_count ||
            ' (expected ' || p_expect || ')'
        );

        l_failures := l_failures + 1;
    END IF;
END check_count;

BEGIN

DBMS_OUTPUT.PUT_LINE('Checking release state...');
DBMS_OUTPUT.PUT_LINE('---------------------------------------------');

SELECT COUNT(*)
  INTO l_count
  FROM USER_TABLES
 WHERE TABLE_NAME = 'APP_SCHEMA_VERSION';

check_count(
    'APP_SCHEMA_VERSION table',
    l_count,
    1
);

SELECT COUNT(*)
  INTO l_count
  FROM USER_TABLES
 WHERE TABLE_NAME IN (
     'APP_USERS',
     'APP_ROLES',
     'APP_PERMISSIONS',
     'APP_ROLE_PERMISSIONS',
     'APP_USER_ROLES'
 );

check_count(
    'Identity tables',
    l_count,
    5
);

SELECT COUNT(*)
  INTO l_count
  FROM USER_TABLES
 WHERE TABLE_NAME IN (
     'APP_SESSIONS',
     'APP_LOGIN_ATTEMPTS',
     'APP_LOGIN_HISTORY',
     'APP_PASSWORD_HISTORY'
 );

check_count(
    'Security tables',
    l_count,
    4
);

SELECT COUNT(*)
  INTO l_count
  FROM USER_TABLES
 WHERE TABLE_NAME = 'APP_FILE_METADATA';

check_count(
    'APP_FILE_METADATA table',
    l_count,
    1
);

SELECT COUNT(*)
  INTO l_count
  FROM USER_OBJECTS
 WHERE OBJECT_NAME = 'PKG_ERRORS'
   AND OBJECT_TYPE = 'PACKAGE'
   AND STATUS = 'VALID';

check_count(
    'PKG_ERRORS package',
    l_count,
    1
);

SELECT COUNT(*)
  INTO l_count
  FROM USER_OBJECTS
 WHERE OBJECT_NAME = 'PKG_ERRORS'
   AND OBJECT_TYPE = 'PACKAGE BODY'
   AND STATUS = 'VALID';

check_count(
    'PKG_ERRORS package body',
    l_count,
    1
);

SELECT COUNT(*)
  INTO l_count
  FROM USER_OBJECTS
 WHERE OBJECT_NAME IN (
     'PKG_IDENTITY',
     'PKG_SECURITY_HASH',
     'PKG_SESSION',
     'PKG_AUTHENTICATION',
     'PKG_SECURITY_POLICY'
 )
   AND OBJECT_TYPE = 'PACKAGE'
   AND STATUS = 'VALID';

check_count(
    'Application packages',
    l_count,
    5
);

SELECT COUNT(*)
  INTO l_count
  FROM USER_OBJECTS
 WHERE OBJECT_NAME IN (
     'PKG_IDENTITY',
     'PKG_SECURITY_HASH',
     'PKG_SESSION',
     'PKG_AUTHENTICATION',
     'PKG_SECURITY_POLICY'
 )
   AND OBJECT_TYPE = 'PACKAGE BODY'
   AND STATUS = 'VALID';

check_count(
    'Application package bodies',
    l_count,
    5
);

SELECT COUNT(*)
  INTO l_count
  FROM APP_ROLE_PERMISSIONS rp
 WHERE NOT EXISTS (
     SELECT 1
       FROM APP_ROLES r
      WHERE r.ROLE_ID = rp.ROLE_ID
 );

check_count(
    'Orphan RBAC records',
    l_count,
    0
);

SELECT COUNT(*)
  INTO l_count
  FROM APP_SCHEMA_VERSION
 WHERE VERSION_NO = '2.3.0-alpha.1';

IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE(
        '[INFO] Version 2.3.0-alpha.1 is not yet registered.'
    );
ELSE
    DBMS_OUTPUT.PUT_LINE(
        '[INFO] Version 2.3.0-alpha.1 already registered.'
    );
END IF;

DBMS_OUTPUT.PUT_LINE('---------------------------------------------');

IF l_failures > 0 THEN
    DBMS_OUTPUT.PUT_LINE(
        '[FAIL] Release dry-run failed: ' ||
        l_failures ||
        ' check(s).'
    );

    RAISE_APPLICATION_ERROR(
        -20991,
        'Release dry-run failed: ' ||
        l_failures ||
        ' check(s).'
    );
END IF;

DBMS_OUTPUT.PUT_LINE(
    '[PASS] All release checks passed.'
);

DBMS_OUTPUT.PUT_LINE(
    'RELEASE DRY-RUN PASSED'
);

DBMS_OUTPUT.PUT_LINE(
    'No database changes were performed.'
);

END;
/

PROMPT ============================================================================
PROMPT Release dry-run completed successfully.
PROMPT ============================================================================

EXIT SUCCESS

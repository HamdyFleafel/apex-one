
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Database Build System
-- Component      : Post-Build Health Check
-- Object Name    : BUILD_HEALTHCHECK
-- Object Type    : SCRIPT
-- File           : build_healthcheck.sql
-- Path           : database/build/build_healthcheck.sql
-- Schema         : APEXONE
-- Version        : 2.3.0-alpha.1
-- Status         : Development
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
--
-- Description    : Performs a comprehensive post-build validation of the
--                  APEXONE database installation.
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Database Build System
-- Component      : Post-Build Health Check
-- Object Name    : BUILD_HEALTHCHECK
-- Object Type    : SCRIPT
-- File           : database/build/build_healthcheck.sql
-- Schema         : APEXONE
-- Version        : 2.4.0-alpha.1
-- Status         : Development
--
-- Description    : Comprehensive post-build validation for the current
--                  APEXONE database schema contract.
--
--                  The health check validates:
--                    1. Required Identity / Security tables
--                    2. Core file metadata table
--                    3. Required primary-key constraints
--                    4. Required unique constraints
--                    5. Required foreign-key constraints
--                    6. APP_FILE_METADATA constraints
--                    7. Constraint-backed indexes
--                    8. APP_FILE_METADATA supporting indexes
--                    9. Application table tablespaces
--                   10. Application index tablespaces
--                   11. INVALID indexes
--                   12. INVALID executable/schema objects
--                   13. APP_FILE_METADATA column integrity
--
--                  Expected constraint/index names match the currently
--                  installed APEXONE schema.
--
-- Change Log:
--   2026-08-16  HF  Updated constraint/index contract to match installed
--                   schema; corrected PK/UK/FK names and included the
--                   configuration/notification foreign keys.
-- =============================================================================

SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK ON
SET HEADING ON
SET PAGESIZE 100
SET LINESIZE 200
SET TAB OFF
SET TRIMSPOOL ON

WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT
PROMPT ============================================================================
PROMPT APEXONE ENTERPRISE DATABASE POST-BUILD HEALTH CHECK
PROMPT ============================================================================
PROMPT
PROMPT Schema           : APEXONE
PROMPT Data Tablespace  : APEXONE_DATA
PROMPT Index Tablespace : APEXONE_INDEX
PROMPT Audit Tablespace : APEXONE_AUDIT
PROMPT
PROMPT Validating Identity, Security and Core File Metadata layers...
PROMPT
PROMPT ============================================================================

DECLARE
    l_count NUMBER := 0;
    l_fail  NUMBER := 0;

    PROCEDURE check_result (
        p_label    IN VARCHAR2,
        p_actual   IN NUMBER,
        p_expected IN NUMBER
    )
    IS
    BEGIN
        IF p_actual = p_expected THEN
            DBMS_OUTPUT.PUT_LINE(
                '[OK] ' || p_label || ': ' ||
                p_actual || ' / ' || p_expected
            );
        ELSE
            DBMS_OUTPUT.PUT_LINE(
                '[FAIL] ' || p_label || ': ' ||
                p_actual || ' / ' || p_expected
            );
            l_fail := l_fail + 1;
        END IF;
    END check_result;

BEGIN

    -- =========================================================================
    -- 1. Required Identity / Security Tables
    -- =========================================================================

    DBMS_OUTPUT.PUT_LINE(
        'Checking required Identity/Security tables...'
    );

    SELECT COUNT(*)
      INTO l_count
      FROM USER_TABLES
     WHERE TABLE_NAME IN (
           'APP_USERS',
           'APP_ROLES',
           'APP_PERMISSIONS',
           'APP_ROLE_PERMISSIONS',
           'APP_USER_ROLES',
           'APP_SESSIONS',
           'APP_LOGIN_ATTEMPTS',
           'APP_LOGIN_HISTORY',
           'APP_PASSWORD_HISTORY'
     );

    check_result(
        'Required Identity/Security tables',
        l_count,
        9
    );

    -- =========================================================================
    -- 2. Core File Metadata Table
    -- =========================================================================

    DBMS_OUTPUT.PUT_LINE(
        'Checking Core file metadata table...'
    );

    SELECT COUNT(*)
      INTO l_count
      FROM USER_TABLES
     WHERE TABLE_NAME = 'APP_FILE_METADATA';

    check_result(
        'APP_FILE_METADATA table',
        l_count,
        1
    );
          -- ============================================================================
-- 3. Required Primary Keys
-- ============================================================================

DBMS_OUTPUT.PUT_LINE(
    'Checking required primary-key constraints...'
);

SELECT COUNT(*)
  INTO l_count
  FROM USER_CONSTRAINTS
 WHERE CONSTRAINT_TYPE = 'P'
   AND STATUS = 'ENABLED'
   AND CONSTRAINT_NAME IN (
       'PK_APP_USERS',
       'PK_APP_ROLES',
       'PK_APP_PERMISSIONS',
       'PK_APP_ROLE_PERMISSIONS',
       'PK_APP_USER_ROLES',
       'PK_APP_SESSIONS',
       'PK_APP_LOGIN_ATTEMPTS',
       'PK_APP_LOGIN_HISTORY',
       'PK_APP_PASSWORD_HISTORY',
       'PK_APP_SECURITY_AUDIT',
       'APP_FILE_METADATA_PK'
   );

check_result(
    'Required primary keys',
    l_count,
    11
);
    -- =========================================================================
    -- 4. Required Unique Constraints
    -- =========================================================================

    DBMS_OUTPUT.PUT_LINE(
        'Checking required unique constraints...'
    );

    SELECT COUNT(*)
      INTO l_count
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_TYPE = 'U'
       AND STATUS = 'ENABLED'
       AND CONSTRAINT_NAME IN (
           'UK_APP_USERS_USERNAME',
           'UK_APP_USERS_EMAIL',
           'UK_APP_ROLES_CODE',
           'UK_APP_PERMISSIONS_CODE',
           'UK_ROLE_PERMISSION',
           'UK_USER_ROLE',
           'UK_APP_SESSION_TOKEN',
           'APP_FILE_METADATA_PATH_UK'
     );

    check_result(
        'Required unique constraints',
        l_count,
        8
    );

    -- =========================================================================
    -- 5. Required Foreign Keys
    -- =========================================================================

    DBMS_OUTPUT.PUT_LINE(
        'Checking required foreign-key constraints...'
    );

    SELECT COUNT(*)
      INTO l_count
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_TYPE = 'R'
       AND STATUS = 'ENABLED'
       AND CONSTRAINT_NAME IN (
           'APP_CONFIG_GROUP_FK',
           'APP_NOTIFICATIONS_TEMPLATE_FK',
           'FK_APP_PASSWORD_HISTORY_USER',
           'FK_RP_PERMISSION',
           'FK_RP_ROLE',
           'FK_UR_ROLE',
           'FK_UR_USER'
     );

    check_result(
        'Required foreign keys',
        l_count,
        7
    );

    -- =========================================================================
    -- 6. APP_FILE_METADATA Required Constraints
    -- =========================================================================

    DBMS_OUTPUT.PUT_LINE(
        'Checking APP_FILE_METADATA constraints...'
    );

    SELECT COUNT(*)
      INTO l_count
      FROM USER_CONSTRAINTS
     WHERE TABLE_NAME = 'APP_FILE_METADATA'
       AND STATUS = 'ENABLED'
       AND CONSTRAINT_NAME IN (
           'APP_FILE_METADATA_CHECKSUM_CK',
           'APP_FILE_METADATA_PATH_UK',
           'APP_FILE_METADATA_PK',
           'APP_FILE_METADATA_SIZE_CK',
           'APP_FILE_METADATA_STATUS_CK'
     );

    check_result(
        'APP_FILE_METADATA required constraints',
        l_count,
        5
    );

    -- =========================================================================
    -- 7. Constraint-Backed Indexes
    --
    -- Expected installed indexes:
    --
    --   PK_APP_USERS
    --   UK_APP_USERS_USERNAME
    --   UK_APP_USERS_EMAIL
    --   PK_APP_ROLES
    --   UK_APP_ROLES_CODE
    --   PK_APP_PERMISSIONS
    --   UK_APP_PERMISSIONS_CODE
    --   PK_APP_ROLE_PERMISSIONS
    --   UK_ROLE_PERMISSION
    --   PK_APP_USER_ROLES
    --   UK_USER_ROLE
    --   PK_APP_SESSIONS
    --   UK_APP_SESSION_TOKEN
    --   PK_APP_LOGIN_ATTEMPTS
    --   PK_APP_LOGIN_HISTORY
    --   PK_APP_PASSWORD_HISTORY
    --   APP_FILE_METADATA_PK
    --   APP_FILE_METADATA_PATH_UK
    -- =========================================================================

    DBMS_OUTPUT.PUT_LINE(
        'Checking constraint-backed indexes...'
    );

    SELECT COUNT(*)
      INTO l_count
      FROM USER_INDEXES
     WHERE INDEX_NAME IN (
           'PK_APP_USERS',
           'UK_APP_USERS_USERNAME',
           'UK_APP_USERS_EMAIL',
           'PK_APP_ROLES',
           'UK_APP_ROLES_CODE',
           'PK_APP_PERMISSIONS',
           'UK_APP_PERMISSIONS_CODE',
           'PK_APP_ROLE_PERMISSIONS',
           'UK_ROLE_PERMISSION',
           'PK_APP_USER_ROLES',
           'UK_USER_ROLE',
           'PK_APP_SESSIONS',
           'UK_APP_SESSION_TOKEN',
           'PK_APP_LOGIN_ATTEMPTS',
           'PK_APP_PASSWORD_HISTORY',
           'APP_FILE_METADATA_PK',
           'APP_FILE_METADATA_PATH_UK'
     )
       AND STATUS = 'VALID'
       AND TABLESPACE_NAME = 'APEXONE_INDEX';

    check_result(
        'Constraint-backed indexes on APEXONE_INDEX',
        l_count,
        17
    );

    SELECT COUNT(*) INTO l_count
    FROM USER_INDEXES
    WHERE INDEX_NAME IN ('PK_APP_LOGIN_HISTORY','PK_APP_SECURITY_AUDIT')
      AND STATUS = 'VALID'
      AND TABLESPACE_NAME = 'APEXONE_AUDIT';

    check_result(
        'Audit constraint-backed indexes on APEXONE_AUDIT',
        l_count,
        2
    );

    -- =========================================================================
    -- 8. APP_FILE_METADATA Supporting Indexes
    -- =========================================================================

    DBMS_OUTPUT.PUT_LINE(
        'Checking APP_FILE_METADATA indexes...'
    );

    SELECT COUNT(*)
      INTO l_count
      FROM USER_INDEXES
     WHERE TABLE_NAME = 'APP_FILE_METADATA'
       AND INDEX_NAME IN (
           'APP_FILE_METADATA_CREATED_IDX',
           'APP_FILE_METADATA_PATH_UK',
           'APP_FILE_METADATA_PK',
           'APP_FILE_METADATA_STATUS_IDX'
       )
       AND STATUS = 'VALID'
       AND TABLESPACE_NAME = 'APEXONE_INDEX';

    check_result(
        'APP_FILE_METADATA VALID indexes on APEXONE_INDEX',
        l_count,
        4
    );

    -- =========================================================================
    -- 9. Required Application Tables on APEXONE_DATA
    -- =========================================================================

    DBMS_OUTPUT.PUT_LINE(
        'Checking application table tablespaces...'
    );

    SELECT COUNT(*)
      INTO l_count
      FROM USER_TABLES
     WHERE TABLE_NAME IN (
           'APP_USERS',
           'APP_ROLES',
           'APP_PERMISSIONS',
           'APP_ROLE_PERMISSIONS',
           'APP_USER_ROLES',
           'APP_SESSIONS',
           'APP_LOGIN_ATTEMPTS',
           'APP_PASSWORD_HISTORY',
           'APP_FILE_METADATA'
     )
       AND TABLESPACE_NAME = 'APEXONE_DATA';

    check_result(
        'Required application tables on APEXONE_DATA',
        l_count,
        9
    );

    SELECT COUNT(*) INTO l_count
    FROM USER_TABLES
    WHERE TABLE_NAME IN ('APP_LOGIN_HISTORY','APP_SECURITY_AUDIT')
      AND TABLESPACE_NAME = 'APEXONE_AUDIT';

    check_result(
        'Audit tables on APEXONE_AUDIT',
        l_count,
        2
    );

    -- =========================================================================
    -- 10. Required Indexes on APEXONE_INDEX
    -- =========================================================================

    DBMS_OUTPUT.PUT_LINE(
        'Checking application index tablespaces...'
    );

    SELECT COUNT(*)
      INTO l_count
      FROM USER_INDEXES
     WHERE TABLE_NAME IN (
           'APP_USERS',
           'APP_ROLES',
           'APP_PERMISSIONS',
           'APP_ROLE_PERMISSIONS',
           'APP_USER_ROLES',
           'APP_SESSIONS',
           'APP_LOGIN_ATTEMPTS',
           'APP_PASSWORD_HISTORY',
           'APP_FILE_METADATA'
     )
       AND STATUS = 'VALID'
       AND TABLESPACE_NAME <> 'APEXONE_INDEX';

    IF l_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            '[OK] Normal application indexes use APEXONE_INDEX.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            '[FAIL] Normal application indexes found outside APEXONE_INDEX: ' || l_count
        );
        l_fail := l_fail + 1;
    END IF;

    SELECT COUNT(*) INTO l_count
    FROM USER_INDEXES
    WHERE TABLE_NAME IN ('APP_LOGIN_HISTORY','APP_SECURITY_AUDIT')
      AND STATUS = 'VALID'
      AND TABLESPACE_NAME <> 'APEXONE_AUDIT';

    IF l_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[OK] Audit indexes use APEXONE_AUDIT.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Audit indexes found outside APEXONE_AUDIT: ' || l_count);
        l_fail := l_fail + 1;
    END IF;

    -- =========================================================================
    -- 11. INVALID Index Check
    -- =========================================================================

    DBMS_OUTPUT.PUT_LINE(
        'Checking for INVALID indexes...'
    );

    SELECT COUNT(*)
      INTO l_count
      FROM USER_INDEXES
     WHERE TABLE_NAME IN (
           'APP_USERS',
           'APP_ROLES',
           'APP_PERMISSIONS',
           'APP_ROLE_PERMISSIONS',
           'APP_USER_ROLES',
           'APP_SESSIONS',
           'APP_LOGIN_ATTEMPTS',
           'APP_LOGIN_HISTORY',
           'APP_PASSWORD_HISTORY',
           'APP_SECURITY_AUDIT',
           'APP_FILE_METADATA'
     )
       AND STATUS <> 'VALID';

    IF l_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            '[OK] No INVALID indexes found.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            '[FAIL] INVALID indexes found: ' || l_count
        );
        l_fail := l_fail + 1;
    END IF;

    -- =========================================================================
    -- 12. INVALID Executable / Schema Objects
    -- =========================================================================

    DBMS_OUTPUT.PUT_LINE(
        'Checking for INVALID executable/schema objects...'
    );

    SELECT COUNT(*)
      INTO l_count
      FROM USER_OBJECTS
     WHERE STATUS <> 'VALID'
       AND OBJECT_TYPE IN (
           'PACKAGE',
           'PACKAGE BODY',
           'FUNCTION',
           'PROCEDURE',
           'TRIGGER',
           'VIEW'
     );

    IF l_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            '[OK] No INVALID executable/schema objects found.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            '[FAIL] INVALID executable/schema objects found: ' ||
            l_count
        );
        l_fail := l_fail + 1;
    END IF;

    -- =========================================================================
    -- 13. APP_FILE_METADATA Column Integrity
    -- =========================================================================

    DBMS_OUTPUT.PUT_LINE(
        'Checking APP_FILE_METADATA column structure...'
    );

    SELECT COUNT(*)
      INTO l_count
      FROM USER_TAB_COLUMNS
     WHERE TABLE_NAME = 'APP_FILE_METADATA'
       AND COLUMN_NAME IN (
           'FILE_ID',
           'FILE_NAME',
           'RELATIVE_PATH',
           'FILE_EXTENSION',
           'MIME_TYPE',
           'FILE_SIZE_BYTES',
           'CHECKSUM_SHA256',
           'FILE_STATUS',
           'CREATED_AT',
           'PROCESSED_AT',
           'ERROR_MESSAGE'
     );

    check_result(
        'APP_FILE_METADATA required columns',
        l_count,
        11
    );

    -- =========================================================================
    -- 14. Final Result
    -- =========================================================================

    DBMS_OUTPUT.PUT_LINE(
        '----------------------------------------------------------------------------'
    );

    IF l_fail = 0 THEN

        DBMS_OUTPUT.PUT_LINE(
            '[OK] APEXONE Health Check PASSED.'
        );

        DBMS_OUTPUT.PUT_LINE(
            '[OK] Required database objects are present and enabled.'
        );

        DBMS_OUTPUT.PUT_LINE(
            '[OK] Required indexes are VALID.'
        );

        DBMS_OUTPUT.PUT_LINE(
            '[OK] Normal application tables use APEXONE_DATA; audit tables use APEXONE_AUDIT.'
        );

        DBMS_OUTPUT.PUT_LINE(
            '[OK] Normal application indexes use APEXONE_INDEX; audit indexes use APEXONE_AUDIT.'
        );

        DBMS_OUTPUT.PUT_LINE(
            '[OK] Core file metadata layer is healthy.'
        );

        DBMS_OUTPUT.PUT_LINE(
            '[OK] No INVALID executable/schema objects were detected.'
        );

    ELSE

        DBMS_OUTPUT.PUT_LINE(
            '[FAIL] APEXONE Health Check FAILED.'
        );

        DBMS_OUTPUT.PUT_LINE(
            '[FAIL] Failed checks: ' || l_fail
        );

        DBMS_OUTPUT.PUT_LINE(
            '[FAIL] Review the messages above before using the database.'
        );

        RAISE_APPLICATION_ERROR(
            -20001,
            'APEXONE Health Check failed.'
        );

    END IF;

END;
/

PROMPT
PROMPT ============================================================================
PROMPT APEXONE POST-BUILD HEALTH CHECK COMPLETED
PROMPT ============================================================================
PROMPT
PROMPT Health validation completed successfully.
PROMPT
PROMPT Data Tablespace  : APEXONE_DATA
PROMPT Index Tablespace : APEXONE_INDEX
PROMPT Audit Tablespace : APEXONE_AUDIT
PROMPT
PROMPT ============================================================================

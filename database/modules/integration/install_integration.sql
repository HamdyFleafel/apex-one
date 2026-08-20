-- ============================================================================
-- APEXONE Integration Module Installation
-- ============================================================================
-- Execution Root:
-- database/
--
-- This installer must be executed with database/ as the SQL*Plus
-- working directory.
-- ============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK ON

WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT
PROMPT ============================================================================
PROMPT APEXONE Integration Module Install
PROMPT ============================================================================
PROMPT

PROMPT Installing PKG_INTEGRATION specification...

@modules/integration/packages/spec/PKG_INTEGRATION.pks

PROMPT
PROMPT Installing PKG_INTEGRATION package body...

@modules/integration/packages/body/PKG_INTEGRATION.pkb

PROMPT
PROMPT Verifying PKG_INTEGRATION installation...

DECLARE
    l_invalid_count NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO l_invalid_count
      FROM user_objects
     WHERE object_name = 'PKG_INTEGRATION'
       AND object_type IN ('PACKAGE', 'PACKAGE BODY')
       AND status <> 'VALID';

    IF l_invalid_count > 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'PKG_INTEGRATION installation failed: invalid objects found.'
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE(
        'PASS - PKG_INTEGRATION PACKAGE and PACKAGE BODY are VALID'
    );
END;
/

COMMIT;

PROMPT
PROMPT ============================================================================
PROMPT APEXONE Integration Module Install Completed Successfully
PROMPT ============================================================================
PROMPT
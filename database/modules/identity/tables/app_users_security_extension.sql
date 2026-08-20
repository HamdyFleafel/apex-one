-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Tables
-- Object Name    : APP_USERS (Security Extension)
-- Object Type    : ALTER SCRIPT
-- File           : app_users_security_extension.sql
-- Path           : database/modules/identity/tables/app_users_security_extension.sql
-- Schema         : APEXONE
-- Version        : 2.0.0-alpha.1
-- Status         : Development
-- =============================================================================

-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080

-- =============================================================================
-- Description :
--
-- Adds security-related columns to APP_USERS.
--
-- Security ownership remains in the Security module while the columns
-- physically extend the Identity-owned APP_USERS table.
--
-- Password model:
--   PASSWORD_VERIFIER
--   PASSWORD_SALT
--   PASSWORD_CHANGED_AT
--   PASSWORD_EXPIRES_AT
--   FORCE_PASSWORD_RESET
--
-- Account state continues to use:
--   ACCOUNT_STATUS_CODE
--
-- Do NOT introduce a duplicate STATUS column.
-- =============================================================================

PROMPT
PROMPT ============================================================================
PROMPT Extending APP_USERS for Security
PROMPT ============================================================================
PROMPT

SET DEFINE OFF
SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK ON
SET SQLBLANKLINES ON

DECLARE
    l_count NUMBER;
BEGIN

    --------------------------------------------------------------------------
    -- PASSWORD_SALT
    --------------------------------------------------------------------------

    SELECT COUNT(*)
      INTO l_count
      FROM USER_TAB_COLUMNS
     WHERE TABLE_NAME  = 'APP_USERS'
       AND COLUMN_NAME = 'PASSWORD_SALT';

    IF l_count = 0 THEN

        EXECUTE IMMEDIATE
        'ALTER TABLE APP_USERS ADD
        (
            PASSWORD_SALT VARCHAR2(512 CHAR)
        )';

        DBMS_OUTPUT.PUT_LINE(
            'PASSWORD_SALT added to APP_USERS.'
        );

    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'PASSWORD_SALT already exists.'
        );

    END IF;


    --------------------------------------------------------------------------
    -- PASSWORD_CHANGED_AT
    --------------------------------------------------------------------------

    SELECT COUNT(*)
      INTO l_count
      FROM USER_TAB_COLUMNS
     WHERE TABLE_NAME  = 'APP_USERS'
       AND COLUMN_NAME = 'PASSWORD_CHANGED_AT';

    IF l_count = 0 THEN

        EXECUTE IMMEDIATE
        'ALTER TABLE APP_USERS ADD
        (
            PASSWORD_CHANGED_AT TIMESTAMP WITH LOCAL TIME ZONE
        )';

        DBMS_OUTPUT.PUT_LINE(
            'PASSWORD_CHANGED_AT added to APP_USERS.'
        );

    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'PASSWORD_CHANGED_AT already exists.'
        );

    END IF;


    --------------------------------------------------------------------------
    -- PASSWORD_EXPIRES_AT
    --------------------------------------------------------------------------

    SELECT COUNT(*)
      INTO l_count
      FROM USER_TAB_COLUMNS
     WHERE TABLE_NAME  = 'APP_USERS'
       AND COLUMN_NAME = 'PASSWORD_EXPIRES_AT';

    IF l_count = 0 THEN

        EXECUTE IMMEDIATE
        'ALTER TABLE APP_USERS ADD
        (
            PASSWORD_EXPIRES_AT TIMESTAMP WITH LOCAL TIME ZONE
        )';

        DBMS_OUTPUT.PUT_LINE(
            'PASSWORD_EXPIRES_AT added to APP_USERS.'
        );

    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'PASSWORD_EXPIRES_AT already exists.'
        );

    END IF;


    --------------------------------------------------------------------------
    -- FORCE_PASSWORD_RESET
    --------------------------------------------------------------------------

    SELECT COUNT(*)
      INTO l_count
      FROM USER_TAB_COLUMNS
     WHERE TABLE_NAME  = 'APP_USERS'
       AND COLUMN_NAME = 'FORCE_PASSWORD_RESET';

    IF l_count = 0 THEN

        EXECUTE IMMEDIATE
        'ALTER TABLE APP_USERS ADD
        (
            FORCE_PASSWORD_RESET CHAR(1 CHAR)
                DEFAULT ''N''
                NOT NULL
        )';

        DBMS_OUTPUT.PUT_LINE(
            'FORCE_PASSWORD_RESET added to APP_USERS.'
        );

    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'FORCE_PASSWORD_RESET already exists.'
        );

    END IF;

END;
/

COMMIT;

PROMPT
PROMPT APP_USERS security extension completed.
PROMPT
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Tables
-- Object Name    : APP_USERS (Password Policy Extension)
-- Object Type    : TABLE ALTER SCRIPT
-- File           : app_users_password_policy.sql
-- Path           : database/modules/identity/tables/app_users_password_policy.sql
-- Schema         : APEXONE
-- Version        : 1.7.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Adds password expiration and reset policy columns
--                  to APP_USERS table.
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-05
-- Last Modified  : 2026-08-05
-- -----------------------------------------------------------------------------
-- Change Log     :
--   2026-08-05  HF  Initial creation.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

PROMPT ============================================================================
PROMPT Extending APP_USERS with Password Policy Columns
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_TAB_COLUMNS
     WHERE TABLE_NAME = 'APP_USERS'
       AND COLUMN_NAME = 'PASSWORD_CHANGED_AT';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE '
            ALTER TABLE APP_USERS
            ADD (
                PASSWORD_CHANGED_AT TIMESTAMP WITH LOCAL TIME ZONE,
                PASSWORD_EXPIRES_AT TIMESTAMP WITH LOCAL TIME ZONE,
                FORCE_PASSWORD_RESET CHAR(1) DEFAULT ''N'' NOT NULL
            )
        ';

        DBMS_OUTPUT.PUT_LINE('Password policy columns added.');

    ELSE
        DBMS_OUTPUT.PUT_LINE('Password policy columns already exist.');
    END IF;

END;
/

COMMIT;
PROMPT Completed.
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Constraints
-- Object Name    : FK_APP_PASSWORD_HISTORY_USER
-- Object Type    : FOREIGN KEY CONSTRAINT
-- File           : app_password_history_user_fk.sql
-- Path           : database/modules/security/constraints/app_password_history_user_fk.sql
-- Schema         : APEXONE
-- Version        : 1.8.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Links APP_PASSWORD_HISTORY.USER_ID to APP_USERS.
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-05
-- Last Modified  : 2026-08-05
-- -----------------------------------------------------------------------------
-- Change Log     :
--   2026-08-05  HF  Initial creation.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

PROMPT Adding FK_APP_PASSWORD_HISTORY_USER

DECLARE
    l_exists NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'FK_APP_PASSWORD_HISTORY_USER'
       AND TABLE_NAME      = 'APP_PASSWORD_HISTORY'
       AND CONSTRAINT_TYPE = 'R';

    IF l_exists = 0 THEN
        EXECUTE IMMEDIATE '
            ALTER TABLE APP_PASSWORD_HISTORY
            ADD CONSTRAINT FK_APP_PASSWORD_HISTORY_USER
            FOREIGN KEY (USER_ID)
            REFERENCES APP_USERS (USER_ID)
        ';
    END IF;
END;
/

COMMIT;
PROMPT Completed.
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Constraints
-- Object Name    : CK_APP_SECURITY_AUDIT_RESULT
-- Object Type    : CHECK CONSTRAINT
-- File           : app_security_audit_result_ck.sql
-- Path           : database/modules/security/constraints/app_security_audit_result_ck.sql
-- Schema         : APEXONE
-- Version        : 1.8.0-alpha.1
-- Status         : Development
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
--
-- Description    : Restricts security audit results to supported values.
--
-- Created On     : 2026-08-12
-- Last Modified  : 2026-08-12
--
-- Change Log     :
--   2026-08-12  HF  Initial creation.
--
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating constraint CK_APP_SECURITY_AUDIT_RESULT
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO l_exists
    FROM USER_CONSTRAINTS
    WHERE TABLE_NAME = 'APP_SECURITY_AUDIT'
      AND CONSTRAINT_NAME = 'CK_APP_SECURITY_AUDIT_RESULT';

    IF l_exists = 0 THEN
        EXECUTE IMMEDIATE q'[
            ALTER TABLE APP_SECURITY_AUDIT
            ADD CONSTRAINT CK_APP_SECURITY_AUDIT_RESULT
            CHECK (RESULT IN ('SUCCESS', 'FAILURE', 'DENIED'))
        ]';

        DBMS_OUTPUT.PUT_LINE(
            'CK_APP_SECURITY_AUDIT_RESULT created.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            'CK_APP_SECURITY_AUDIT_RESULT already exists.'
        );
    END IF;
END;
/

COMMIT;

PROMPT Completed.
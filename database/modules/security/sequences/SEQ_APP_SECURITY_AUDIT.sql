-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Sequences
-- Object Name    : SEQ_APP_SECURITY_AUDIT
-- Object Type    : SEQUENCE
-- File           : SEQ_APP_SECURITY_AUDIT.sql
-- Path           : database/modules/security/sequences/SEQ_APP_SECURITY_AUDIT.sql
-- Schema         : APEXONE
-- Version        : 1.8.0-alpha.1
-- Status         : Development
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
--
-- Description    : Generates identifiers for centralized security audit events.
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
PROMPT Creating SEQ_APP_SECURITY_AUDIT
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO l_exists
    FROM USER_SEQUENCES
    WHERE SEQUENCE_NAME = 'SEQ_APP_SECURITY_AUDIT';

    IF l_exists = 0 THEN
        EXECUTE IMMEDIATE q'[
            CREATE SEQUENCE SEQ_APP_SECURITY_AUDIT
                START WITH 1
                INCREMENT BY 1
                NOCACHE
                NOCYCLE
        ]';

        DBMS_OUTPUT.PUT_LINE(
            'SEQ_APP_SECURITY_AUDIT created.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            'SEQ_APP_SECURITY_AUDIT already exists.'
        );
    END IF;
END;
/

COMMIT;

PROMPT Completed.
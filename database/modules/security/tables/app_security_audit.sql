-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Tables
-- Object Name    : APP_SECURITY_AUDIT
-- Object Type    : TABLE
-- File           : app_security_audit.sql
-- Path           : database/modules/security/tables/app_security_audit.sql
-- Schema         : APEXONE
-- Version        : 1.8.0-alpha.1
-- Status         : Development
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
--
-- Description    : Stores centralized security audit events.
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
PROMPT Creating APP_SECURITY_AUDIT
PROMPT ============================================================================

DECLARE
    l_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO l_exists
    FROM USER_TABLES
    WHERE TABLE_NAME = 'APP_SECURITY_AUDIT';

    IF l_exists = 0 THEN
        EXECUTE IMMEDIATE q'[
            CREATE TABLE APP_SECURITY_AUDIT
            (
                AUDIT_ID        NUMBER NOT NULL,
                EVENT_TYPE      VARCHAR2(100) NOT NULL,
                EVENT_TIME      TIMESTAMP(6) WITH LOCAL TIME ZONE NOT NULL,
                USER_ID         NUMBER,
                USERNAME        VARCHAR2(400),
                SESSION_ID      VARCHAR2(400),
                IP_ADDRESS      VARCHAR2(100),
                OBJECT_TYPE     VARCHAR2(100),
                OBJECT_ID       VARCHAR2(400),
                ACTION          VARCHAR2(200),
                RESULT          VARCHAR2(30) NOT NULL,
                ERROR_CODE      VARCHAR2(100),
                ERROR_MESSAGE   VARCHAR2(2000),
                CONSTRAINT PK_APP_SECURITY_AUDIT
                    PRIMARY KEY (AUDIT_ID)
                    USING INDEX TABLESPACE APEXONE_AUDIT
            )
            TABLESPACE APEXONE_AUDIT
        ]';

        DBMS_OUTPUT.PUT_LINE('APP_SECURITY_AUDIT created.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('APP_SECURITY_AUDIT already exists.');
    END IF;
END;
/

COMMIT;

PROMPT Completed.
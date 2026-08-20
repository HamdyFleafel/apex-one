-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Sequences
-- Object Name    : SEQ_APP_USER_ROLES
-- Object Type    : SEQUENCE
-- File           : SEQ_APP_USER_ROLES.sql
-- Path           : database/modules/identity/sequences/SEQ_APP_USER_ROLES.sql
-- Schema         : APEXONE
-- Version        : 1.2.0-alpha.1
-- Status         : Development
-- =============================================================================

-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080

-- =============================================================================
-- Description    : Generates primary keys for APP_USER_ROLES table.
--
--                  Used for user-to-role RBAC assignments.
--
--                  Installation is idempotent.
-- =============================================================================

-- Created On     : 2026-08-09
-- Last Modified  : 2026-08-09

-- =============================================================================
-- Change Log     :
--   2026-08-09  HF  Added idempotent sequence installation.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF

DECLARE
    v_count NUMBER;
BEGIN

    SELECT COUNT(*)
    INTO v_count
    FROM USER_SEQUENCES
    WHERE SEQUENCE_NAME = 'SEQ_APP_USER_ROLES';

    IF v_count = 0 THEN

        EXECUTE IMMEDIATE '
            CREATE SEQUENCE SEQ_APP_USER_ROLES
            START WITH 1
            INCREMENT BY 1
            MINVALUE 1
            CACHE 100
            NOCYCLE
            NOORDER
        ';

        DBMS_OUTPUT.PUT_LINE(
            'Sequence SEQ_APP_USER_ROLES created.'
        );

    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'Sequence SEQ_APP_USER_ROLES already exists.'
        );

    END IF;

END;
/
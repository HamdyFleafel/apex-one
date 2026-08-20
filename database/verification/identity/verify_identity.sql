-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Verification
-- Object Name    : VERIFY_IDENTITY
-- Object Type    : SCRIPT
-- File           : verify_identity.sql
-- Path           : database/verification/identity/verify_identity.sql
-- Schema         : APEXONE
-- Version        : 1.9.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Verifies Identity module structural integrity.
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
PROMPT Verifying Identity Module
PROMPT ============================================================================

SET SERVEROUTPUT ON

DECLARE
    l_count NUMBER;
BEGIN

    SELECT COUNT(*) INTO l_count FROM USER_TABLES
     WHERE TABLE_NAME IN
     ('APP_USERS','APP_ROLES','APP_PERMISSIONS',
      'APP_ROLE_PERMISSIONS','APP_USER_ROLES');

    IF l_count <> 5 THEN
        RAISE_APPLICATION_ERROR(-20002,'Identity tables missing.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Identity tables verified.');

END;
/

PROMPT Identity verification completed.
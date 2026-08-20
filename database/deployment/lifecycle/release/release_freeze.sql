-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Lifecycle
-- Component      : Release Management
-- Object Name    : RELEASE_FREEZE
-- Object Type    : SCRIPT
-- File           : release_freeze.sql
-- Path           : database/deployment/installment/lifecycle/release/release_freeze.sql
-- Schema         : APEXONE
-- Version        : 1.0.0-beta.1
-- Status         : Release Candidate
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Freezes database state and records official release version.
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
PROMPT Freezing Release Version 1.0.0-beta.1
PROMPT ============================================================================

SET SERVEROUTPUT ON

BEGIN

    INSERT INTO APP_SCHEMA_VERSION
    (
        VERSION_NO,
        SCRIPT_NAME,
        DESCRIPTION,
        STATUS
    )
    VALUES
    (
        '1.0.0-beta.1',
        'release_freeze.sql',
        'Enterprise Security Hardened Release',
        'SUCCESS'
    );

    DBMS_OUTPUT.PUT_LINE('Release version recorded successfully.');

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Release version already recorded.');

END;
/

COMMIT;

PROMPT ============================================================================
PROMPT Release Freeze Completed
PROMPT ============================================================================
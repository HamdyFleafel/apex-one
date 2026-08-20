-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Verification
-- Object Name    : VERIFY_IDENTITY
-- Object Type    : VERIFICATION SCRIPT
-- File           : verify_identity.sql
-- Path           : database\modules\identity\verify_identity.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- -----------------------------------------------------------------------------
-- Description    : Verifies successful installation of the Identity module.
-- =============================================================================

PROMPT =============================================================================
PROMPT Verifying Identity Module
PROMPT =============================================================================

@verification/identity/verify_identity.sql

PROMPT =============================================================================
PROMPT Identity Verification Completed
PROMPT =============================================================================
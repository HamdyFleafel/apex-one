-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Database Build System
-- Component      : Verification Build Orchestration
-- Object Name    : BUILD_VERIFICATION
-- Object Type    : SCRIPT
-- File           : build_verification.sql
-- Path           : database/build/build_verification.sql
-- Schema         : APEXONE
-- Version        : 2.3.0-alpha.1
-- Status         : Development
-- =============================================================================
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- =============================================================================
-- Description    : Verification orchestration script for the APEXONE
--                  Enterprise Platform.
--
--                  This script executes the database verification layer
--                  after the required platform modules have been installed.
--
--                  Verification execution order:
--
--                      1. Identity verification
--                      2. RBAC integrity verification
--                      3. Security verification
--
--                  The script does not create or modify application objects.
--                  It is intended to validate the integrity and expected
--                  state of the installed database modules.
--
--                  The script is intended to be executed from the
--                  database/ working directory.
-- =============================================================================
-- Created On     : 2026-08-09
-- Last Modified  : 2026-08-09
-- =============================================================================
-- Change Log     :
--   2026-08-09  HF  Created dedicated verification build orchestration script.
-- =============================================================================
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================


PROMPT ============================================================================
PROMPT APEXONE Database Verification
PROMPT ============================================================================

WHENEVER SQLERROR EXIT FAILURE ROLLBACK


PROMPT ----------------------------------------------------------------------------
PROMPT Step 1: Running Identity Verification
PROMPT ----------------------------------------------------------------------------

@verification/identity/verify_identity.sql


PROMPT ----------------------------------------------------------------------------
PROMPT Step 2: Running Integration Structural Verification
PROMPT ----------------------------------------------------------------------------

@verification/integration/verify_integration.sql


PROMPT ----------------------------------------------------------------------------
PROMPT Step 3: Running RBAC Integrity Verification
PROMPT ----------------------------------------------------------------------------

@verification/identity/verify_rbac_integrity.sql


PROMPT ----------------------------------------------------------------------------
PROMPT Step 4: Running Security Verification
PROMPT ----------------------------------------------------------------------------

@verification/security/verify_security.sql


PROMPT ----------------------------------------------------------------------------
PROMPT Verification Layer Completed Successfully
PROMPT ----------------------------------------------------------------------------

PROMPT ============================================================================
PROMPT APEXONE Database Verification Completed Successfully
PROMPT ============================================================================


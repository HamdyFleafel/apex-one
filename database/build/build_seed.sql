
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Database Build System
-- Component      : Seed Data Build
-- Object Name    : BUILD_SEED
-- Object Type    : SCRIPT
-- File           : build_seed.sql
-- Path           : database/build/build_seed.sql
-- Schema         : APEXONE
-- Version        : 2.3.0-alpha.1
-- Status         : Development
-- =============================================================================
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- =============================================================================
-- Description    : Seed-data orchestration script for the APEXONE
--                  Enterprise Platform.
--
--                  This script loads the required initial security and
--                  identity seed data in dependency order.
--
--                  Seed execution order:
--
--                      1. Security Roles
--                      2. Security Permissions
--                      3. Role / Permission Relationships
--                      4. Initial Administrator User
--
--                  The script is intended to be executed from the
--                  database/ working directory.
--
--                  This script does not create tables, constraints,
--                  indexes, packages, or application modules.
-- =============================================================================
-- Created On     : 2026-08-09
-- Last Modified  : 2026-08-09
-- =============================================================================
-- Change Log     :
--   2026-08-09  HF  Created dedicated seed build orchestration script.
-- =============================================================================
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================


PROMPT ============================================================================
PROMPT APEXONE Seed Data Build
PROMPT ============================================================================

WHENEVER SQLERROR EXIT FAILURE ROLLBACK


PROMPT ----------------------------------------------------------------------------
PROMPT Step 1: Loading Security Roles
PROMPT ----------------------------------------------------------------------------

@seed/security/seed_roles.sql


PROMPT ----------------------------------------------------------------------------
PROMPT Step 2: Loading Security Permissions
PROMPT ----------------------------------------------------------------------------

@seed/security/seed_permissions.sql


PROMPT ----------------------------------------------------------------------------
PROMPT Step 3: Loading Role / Permission Relationships
PROMPT ----------------------------------------------------------------------------

@seed/security/seed_role_permissions.sql


PROMPT ----------------------------------------------------------------------------
PROMPT Step 4: Creating Initial Administrator User
PROMPT ----------------------------------------------------------------------------

@seed/identity/seed_admin_user.sql


PROMPT ----------------------------------------------------------------------------
PROMPT Step 5: Recording Schema Version
PROMPT ----------------------------------------------------------------------------

@seed/core/seed_schema_version.sql


PROMPT ----------------------------------------------------------------------------
PROMPT Seed Data Build Completed Successfully
PROMPT ----------------------------------------------------------------------------

PROMPT ============================================================================
PROMPT APEXONE Seed Data Build Completed Successfully
PROMPT ============================================================================



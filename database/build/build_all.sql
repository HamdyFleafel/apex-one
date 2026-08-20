
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Database Build System
-- Component      : Master Build Orchestration
-- Object Name    : BUILD_ALL
-- Object Type    : SQL*Plus Script
-- File           : build_all.sql
-- Path           : database/build/build_all.sql
-- Schema         : APEXONE
-- Version        : 2.3.0-alpha.1
-- Status         : Development
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafal@belcofarms.com
-- WhatsApp       : 0020 1010506080
--
-- Description    :
--   Master orchestration script for the complete APEXONE database build.
--
--   The build is intentionally divided into dedicated stages:
--
--       1. Framework
--       2. Enterprise Modules
--       3. Seed Data
--       4. Database Verification
--       5. Post-Build Health Check
--
--   Each stage is delegated to its own build script so that the individual
--   scripts can also be executed independently when required.
--
--   Dependency order:
--
--       Framework
--           |
--           v
--       Core
--           |
--           v
--       Identity
--           |
--           v
--       Security / Audit / Configuration / Notification / Workflow
--           |
--           v
--       Seed Data
--           |
--           v
--       Verification
--           |
--           v
--       Health Check
--
-- Important:
--   This script does NOT directly create database objects.
--   It orchestrates the specialized build scripts.
--
-- Created On     : 2026-08-05
-- Last Modified  : 2026-08-09
--
-- Change Log:
--
--   2026-08-05  HF  Initial master build orchestration.
--   2026-08-09  HF  Refactored master build to delegate execution to the
--                   dedicated framework, modules, seed, verification and
--                   health-check scripts.
--
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================


-- =============================================================================
-- SQL*Plus Environment
-- =============================================================================

SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK ON
SET HEADING ON
SET PAGESIZE 100
SET LINESIZE 200
SET TAB OFF
SET TRIMSPOOL ON
SET DEFINE OFF
SET SQLBLANKLINES ON

WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK


-- =============================================================================
-- Build Header
-- =============================================================================

PROMPT
PROMPT ============================================================================
PROMPT APEXONE ENTERPRISE DATABASE BUILD
PROMPT ============================================================================
PROMPT
PROMPT Schema           : APEXONE
PROMPT Data Tablespace  : APEXONE_DATA
PROMPT Index Tablespace : APEXONE_INDEX
PROMPT
PROMPT Build Mode       : FULL
PROMPT
PROMPT ============================================================================
PROMPT


-- =============================================================================
-- Stage 1 - Framework
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [1/5] BUILDING FRAMEWORK
PROMPT ----------------------------------------------------------------------------
PROMPT
PROMPT Delegating to: build_framework.sql
PROMPT

@@build_framework.sql

PROMPT
PROMPT [1/5] Framework stage completed successfully.
PROMPT


-- =============================================================================
-- Stage 2 - Enterprise Modules
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [2/5] BUILDING ENTERPRISE MODULES
PROMPT ----------------------------------------------------------------------------
PROMPT
PROMPT Delegating to: build_modules.sql
PROMPT

@@build_modules.sql

PROMPT
PROMPT [2/5] Enterprise modules stage completed successfully.
PROMPT


-- =============================================================================
-- Stage 3 - Seed Data
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [3/5] BUILDING SEED DATA
PROMPT ----------------------------------------------------------------------------
PROMPT
PROMPT Delegating to: build_seed.sql
PROMPT

@@build_seed.sql

PROMPT
PROMPT [3/5] Seed data stage completed successfully.
PROMPT


-- =============================================================================
-- Stage 4 - Database Verification
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [4/5] RUNNING DATABASE VERIFICATION
PROMPT ----------------------------------------------------------------------------
PROMPT
PROMPT Delegating to: build_verification.sql
PROMPT

@@build_verification.sql

PROMPT
PROMPT [4/5] Database verification stage completed successfully.
PROMPT


-- =============================================================================
-- Stage 5 - Post-Build Health Check
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [5/5] RUNNING POST-BUILD HEALTH CHECK
PROMPT ----------------------------------------------------------------------------
PROMPT
PROMPT Delegating to: build_healthcheck.sql
PROMPT

@@build_healthcheck.sql

PROMPT
PROMPT [5/5] Post-build health check completed successfully.
PROMPT


-- =============================================================================
-- Final Result
-- =============================================================================

PROMPT
PROMPT ============================================================================
PROMPT APEXONE DATABASE BUILD COMPLETED SUCCESSFULLY
PROMPT ============================================================================
PROMPT
PROMPT Build stages:
PROMPT
PROMPT   [1] Framework            : COMPLETED
PROMPT   [2] Enterprise Modules   : COMPLETED
PROMPT   [3] Seed Data            : COMPLETED
PROMPT   [4] Verification         : PASSED
PROMPT   [5] Health Check         : PASSED
PROMPT
PROMPT Data Tablespace  : APEXONE_DATA
PROMPT Index Tablespace : APEXONE_INDEX
PROMPT
PROMPT The APEXONE database is ready for use.
PROMPT
PROMPT ============================================================================
PROMPT


-- =============================================================================
-- End of Script
-- =============================================================================


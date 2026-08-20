
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Database Build System
-- Component      : Database Rebuild
-- Object Name    : REBUILD_DATABASE
-- Object Type    : SCRIPT
-- File           : rebuild_database.sql
-- Path           : database/build/rebuild_database.sql
-- Schema         : APEXONE
-- Version        : 2.3.0-alpha.1
-- Status         : Development
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
--
-- Description    : Master database rebuild orchestration script.
--
--                  Performs a controlled full database rebuild by executing:
--
--                  1. Database cleanup
--                  2. Complete database build
--                  3. Post-build health verification
--
--                  The script is intended for development, testing, CI,
--                  and controlled database refresh operations.
--
--                  IMPORTANT:
--                  This operation is destructive. Existing APEXONE database
--                  objects may be removed during the cleanup phase.
--
-- Created On     : 2026-08-09
-- Last Modified  : 2026-08-09
--
-- Change Log     :
--   2026-08-09  HF  Added complete database rebuild orchestration.
--
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================


SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK ON
SET ECHO OFF


WHENEVER SQLERROR EXIT FAILURE ROLLBACK


PROMPT
PROMPT ============================================================================
PROMPT APEXONE ENTERPRISE DATABASE REBUILD
PROMPT ============================================================================
PROMPT
PROMPT WARNING:
PROMPT This operation will clean the existing APEXONE database objects
PROMPT before rebuilding the database from source.
PROMPT
PROMPT Rebuild sequence:
PROMPT   1. Database Cleanup
PROMPT   2. Full Database Build
PROMPT   3. Post-Build Health Check
PROMPT
PROMPT ============================================================================


-- -----------------------------------------------------------------------------
-- Step 1: Database Cleanup
-- -----------------------------------------------------------------------------
PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT Step 1: Database Cleanup
PROMPT ----------------------------------------------------------------------------
PROMPT

@@clean_database.sql

PROMPT
PROMPT Database cleanup completed successfully.
PROMPT


-- -----------------------------------------------------------------------------
-- Step 2: Full Database Build
-- -----------------------------------------------------------------------------
PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT Step 2: Full Database Build
PROMPT ----------------------------------------------------------------------------
PROMPT

@@build_all.sql

PROMPT
PROMPT Full database build completed successfully.
PROMPT


-- -----------------------------------------------------------------------------
-- Step 3: Post-Build Health Check
-- -----------------------------------------------------------------------------
PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT Step 3: Post-Build Health Check
PROMPT ----------------------------------------------------------------------------
PROMPT

@@build_healthcheck.sql

PROMPT
PROMPT Post-build health check completed successfully.
PROMPT


-- -----------------------------------------------------------------------------
-- Rebuild Completion
-- -----------------------------------------------------------------------------
PROMPT
PROMPT ============================================================================
PROMPT APEXONE DATABASE REBUILD COMPLETED SUCCESSFULLY
PROMPT ============================================================================
PROMPT
PROMPT Rebuild sequence completed:
PROMPT
PROMPT   [1] Database Cleanup       : COMPLETED
PROMPT   [2] Full Database Build    : COMPLETED
PROMPT   [3] Health Check           : COMPLETED
PROMPT
PROMPT The APEXONE database is ready for use.
PROMPT ============================================================================
PROMPT


EXIT SUCCESS


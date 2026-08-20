
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Core
-- Component      : Constraints
-- Object Name    : CORE_CONSTRAINTS
-- Object Type    : SCRIPT
-- File           : core_constraints.sql
-- Path           : database/modules/core/constraints/core_constraints.sql
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
--
-- Description    : Installs all Core module table constraints in deterministic
--                  dependency order.
--
--                  APP_FILE_METADATA constraints are maintained as individual
--                  constraint scripts. This aggregator is the single entry
--                  point for Core constraint installation.
--
-- Created On     : 2026-08-08
-- Last Modified  : 2026-08-09
--
-- Change Log :
-- 2026-08-08 HF Replaced placeholder with APP_FILE_METADATA constraints.
-- 2026-08-09 HF Restored PK and Path UK installation to the aggregator.
-- 2026-08-09 HF Established single ownership for all Core constraints.
--
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

-- =============================================================================
-- SQL*Plus Environment
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET SQLBLANKLINES ON

WHENEVER SQLERROR EXIT FAILURE ROLLBACK

-- =============================================================================
-- Core Constraints Installation
-- =============================================================================

PROMPT
PROMPT ============================================================================
PROMPT APEXONE CORE CONSTRAINTS
PROMPT ============================================================================
PROMPT
PROMPT Installing APP_FILE_METADATA constraints...
PROMPT
PROMPT ============================================================================

-- =============================================================================
-- 1. Primary Key
-- =============================================================================

PROMPT
PROMPT [1/5] Installing APP_FILE_METADATA Primary Key
PROMPT ----------------------------------------------------------------------------

@modules/core/constraints/app_file_metadata_pk.sql

-- =============================================================================
-- 2. Relative Path / File Name Unique Constraint
-- =============================================================================

PROMPT
PROMPT [2/5] Installing APP_FILE_METADATA Path Unique Constraint
PROMPT ----------------------------------------------------------------------------

@modules/core/constraints/app_file_metadata_path_uk.sql

-- =============================================================================
-- 3. File Status Check Constraint
-- =============================================================================

PROMPT
PROMPT [3/5] Installing APP_FILE_METADATA Status Check Constraint
PROMPT ----------------------------------------------------------------------------

@modules/core/constraints/app_file_metadata_status_ck.sql

-- =============================================================================
-- 4. File Size Check Constraint
-- =============================================================================

PROMPT
PROMPT [4/5] Installing APP_FILE_METADATA Size Check Constraint
PROMPT ----------------------------------------------------------------------------

@modules/core/constraints/app_file_metadata_size_ck.sql

-- =============================================================================
-- 5. SHA-256 Checksum Check Constraint
-- =============================================================================

PROMPT
PROMPT [5/5] Installing APP_FILE_METADATA Checksum Check Constraint
PROMPT ----------------------------------------------------------------------------

@modules/core/constraints/app_file_metadata_checksum_ck.sql

-- =============================================================================
-- Completion
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT Core constraints installation completed successfully.
PROMPT ----------------------------------------------------------------------------
PROMPT
PROMPT APP_FILE_METADATA Primary Key : INSTALLED
PROMPT APP_FILE_METADATA Path UK     : INSTALLED
PROMPT APP_FILE_METADATA Status CK   : INSTALLED
PROMPT APP_FILE_METADATA Size CK     : INSTALLED
PROMPT APP_FILE_METADATA Checksum CK : INSTALLED
PROMPT
PROMPT ============================================================================



-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Core
-- Component      : Module Installation
-- Object Name    : INSTALL_CORE
-- Object Type    : SCRIPT
-- File           : install_core.sql
-- Path           : database/modules/core/install_core.sql
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development
-- =============================================================================
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- =============================================================================
-- Description    : Installs the Core module in deterministic dependency order.
--                  Tables are created first, followed by constraints, indexes,
--                  sequences, and packages.
--
--                  APP_FILE_METADATA primary-key and unique constraints are
--                  created by their dedicated constraint scripts using
--                  APEXONE_INDEX as the backing tablespace.
--
-- Created On     : 2026-08-09
-- Last Modified  : 2026-08-09
--
-- Change Log:
-- 2026-08-09 HF Recreated and standardized Core installation entry point.
-- 2026-08-09 HF Preserved deterministic dependency order.
-- =============================================================================
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

-- =============================================================================
-- SQL*Plus Environment
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET HEADING ON
SET SQLBLANKLINES ON
SET TAB OFF
SET TRIMSPOOL ON

WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

-- =============================================================================
-- Core Module Installation Header
-- =============================================================================

PROMPT
PROMPT ============================================================================
PROMPT APEXONE CORE MODULE INSTALLATION
PROMPT ============================================================================
PROMPT
PROMPT Schema           : APEXONE
PROMPT Data Tablespace  : APEXONE_DATA
PROMPT Index Tablespace : APEXONE_INDEX
PROMPT
PROMPT Module           : CORE
PROMPT Version          : 1.3.0-alpha.1
PROMPT
PROMPT Installation Order:
PROMPT   1. Core Tables
PROMPT   2. Core Constraints
PROMPT   3. Core Indexes
PROMPT   4. Core Sequences
PROMPT   5. Core Packages
PROMPT
PROMPT ============================================================================

-- =============================================================================
-- 1. Core Tables
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [1/5] Creating Core Tables
PROMPT ----------------------------------------------------------------------------
PROMPT

@modules/core/tables/app_schema_version.sql
@modules/core/tables/app_install_log.sql
@modules/core/tables/app_file_metadata.sql

PROMPT
PROMPT Core tables installation completed.

-- =============================================================================
-- 2. Core Constraints
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [2/5] Creating Core Constraints
PROMPT ----------------------------------------------------------------------------
PROMPT

@modules/core/constraints/core_constraints.sql

PROMPT
PROMPT Core constraints installation completed.

-- =============================================================================
-- 3. Core Indexes
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [3/5] Creating Core Indexes
PROMPT ----------------------------------------------------------------------------
PROMPT

@modules/core/indexes/core_indexes.sql

PROMPT
PROMPT Core indexes installation completed.

-- =============================================================================
-- 4. Core Sequences
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [4/5] Creating Core Sequences
PROMPT ----------------------------------------------------------------------------
PROMPT

@modules/core/sequences/core_sequences.sql

PROMPT
PROMPT Core sequences installation completed.

-- =============================================================================
-- 5. Core Packages
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [5/5] Creating Core Packages
PROMPT ----------------------------------------------------------------------------



PROMPT Installing PKG_CORE
PROMPT ----------------------------------------------------------------------------

@modules/core/packages/spec/PKG_CORE.pks
@modules/core/packages/body/PKG_CORE.pkb


PROMPT Core packages installation completed.

PROMPT
PROMPT Packages         : CREATED

-- =============================================================================
-- Completion
-- =============================================================================

COMMIT;

PROMPT
PROMPT ============================================================================
PROMPT APEXONE CORE MODULE INSTALLATION COMPLETED
PROMPT ============================================================================
PROMPT
PROMPT Core Status      : INSTALLED
PROMPT
PROMPT Tables           : CREATED
PROMPT Constraints      : CREATED
PROMPT Indexes          : CREATED
PROMPT Sequences        : CREATED
PROMPT Packages         : CREATED
PROMPT
PROMPT Data Tablespace  : APEXONE_DATA
PROMPT Index Tablespace : APEXONE_INDEX
PROMPT
PROMPT ============================================================================
PROMPT



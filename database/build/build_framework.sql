-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Framework
-- Component      : Database Build
-- Object Name    : BUILD_FRAMEWORK
-- Object Type    : SCRIPT
-- File           : build_framework.sql
-- Path           : database/build/build_framework.sql
-- Schema         : APEXONE
-- Version        : 2.0.0-alpha.2
-- Status         : Development
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Created On     : 2026-08-05
-- Last Modified  : 2026-08-09
--
-- Description    :
--   Orchestrates the installation of the APEXONE Framework module.
--
-- Execution Root:
--   database/
--
-- Execution Model:
--   SQL> @build/build_framework.sql
--
-- Dependency Flow:
--   build/build_all.sql
--       |
--       +--> build/build_framework.sql
--                 |
--                 +--> framework/install/install_framework.sql
--
-- Source Directory:
--   database/platform/framework/
--
-- Installation Entry Point:
--   database/platform/framework/install/install_framework.sql
--
-- Important:
--   This script is executed from the database root directory.
--   Therefore all referenced paths are relative to database/.
--
-- Change Log:
--   2026-08-05  HF  Initial framework build script.
--   2026-08-09  HF  Corrected installation path to match the actual
--                   database-root execution model.
--
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
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
-- Framework Build Header
-- =============================================================================

PROMPT
PROMPT ============================================================================
PROMPT APEXONE FRAMEWORK BUILD
PROMPT ============================================================================
PROMPT
PROMPT Schema           : APEXONE
PROMPT Data Tablespace  : APEXONE_DATA
PROMPT Index Tablespace : APEXONE_INDEX
PROMPT
PROMPT Framework Source :
PROMPT database/platform/framework
PROMPT
PROMPT Installation Script :
PROMPT database/platform/framework/install/install_framework.sql
PROMPT
PROMPT Execution Root  :
PROMPT database/
PROMPT
PROMPT ============================================================================

-- =============================================================================
-- Framework Installation
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [1/1] Installing Framework Module
PROMPT ----------------------------------------------------------------------------
PROMPT

@platform/framework/install/install_framework.sql

-- =============================================================================
-- Completion
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT Framework installation completed successfully.
PROMPT ----------------------------------------------------------------------------
PROMPT
PROMPT ============================================================================
PROMPT APEXONE FRAMEWORK BUILD COMPLETED SUCCESSFULLY
PROMPT ============================================================================
PROMPT
PROMPT Framework Status : INSTALLED
PROMPT
PROMPT ============================================================================


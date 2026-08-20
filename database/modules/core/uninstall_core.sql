
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Core
-- Component      : Module Uninstallation
-- Object Name    : UNINSTALL_CORE
-- Object Type    : SCRIPT
-- File           : uninstall_core.sql
-- Path           : database/modules/core/uninstall_core.sql
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
--
-- Description    : Removes the Core module in deterministic reverse
--                  dependency order.
--
--                  Core packages are removed first.
--                  Core tables are removed using CASCADE CONSTRAINTS
--                  and PURGE so that dependent constraints and indexes
--                  are removed by Oracle as part of table cleanup.
--
-- Current Core objects:
--   APP_FILE_METADATA
--   APP_INSTALL_LOG
--   APP_SCHEMA_VERSION
--   PKG_CORE
--
-- No Core sequences are currently installed.
--
-- Created On     : 2026-08-09
-- Last Modified  : 2026-08-09
--
-- Change Log :
-- 2026-08-09 HF Initial Core module uninstallation script.
-- 2026-08-09 HF Reworked table cleanup to use CASCADE CONSTRAINTS PURGE
--               instead of manually dropping constraint-backed indexes.
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
-- Core Module Uninstallation Header
-- =============================================================================

PROMPT
PROMPT ============================================================================
PROMPT APEXONE CORE MODULE UNINSTALLATION
PROMPT ============================================================================
PROMPT
PROMPT Schema           : APEXONE
PROMPT Data Tablespace  : APEXONE_DATA
PROMPT Index Tablespace : APEXONE_INDEX
PROMPT
PROMPT Uninstall order:
PROMPT   [1] Core Package
PROMPT   [2] Core Tables
PROMPT
PROMPT Table cleanup uses:
PROMPT   CASCADE CONSTRAINTS PURGE
PROMPT
PROMPT This removes table-owned constraints and indexes automatically.
PROMPT
PROMPT ============================================================================

-- =============================================================================
-- 1. Drop Core Package
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [1/2] Dropping Core Package
PROMPT ----------------------------------------------------------------------------

BEGIN

    EXECUTE IMMEDIATE 'DROP PACKAGE PKG_CORE';

    DBMS_OUTPUT.PUT_LINE(
        '[OK] PKG_CORE dropped.'
    );

EXCEPTION
    WHEN OTHERS THEN

        IF SQLCODE = -4043 THEN

            DBMS_OUTPUT.PUT_LINE(
                '[SKIP] PKG_CORE does not exist.'
            );

        ELSE

            RAISE;

        END IF;

END;
/

-- =============================================================================
-- 2. Drop Core Tables
--
-- CASCADE CONSTRAINTS removes constraints associated with the table.
-- PURGE permanently removes the table and its dependent storage.
--
-- This also removes indexes owned by the dropped tables, including:
--
--   APP_FILE_METADATA_CREATED_IDX
--   APP_FILE_METADATA_PATH_UK
--   APP_FILE_METADATA_PK
--   APP_FILE_METADATA_STATUS_IDX
--   IDX_APP_INSTALL_LOG_DATE
--   IDX_APP_INSTALL_LOG_STATUS
--   PK_APP_INSTALL_LOG
--   IDX_APP_SCHEMA_VERSION_DATE
--   IDX_APP_SCHEMA_VERSION_STATUS
--   PK_APP_SCHEMA_VERSION
--
-- No manual DROP INDEX statements are required.
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [2/2] Dropping Core Tables
PROMPT ----------------------------------------------------------------------------

BEGIN

    FOR r IN (
        SELECT table_name
          FROM user_tables
         WHERE table_name IN (
             'APP_FILE_METADATA',
             'APP_INSTALL_LOG',
             'APP_SCHEMA_VERSION'
         )
         ORDER BY
             CASE table_name
                 WHEN 'APP_FILE_METADATA'  THEN 1
                 WHEN 'APP_INSTALL_LOG'    THEN 2
                 WHEN 'APP_SCHEMA_VERSION' THEN 3
                 ELSE 99
             END
    )
    LOOP

        EXECUTE IMMEDIATE
            'DROP TABLE "' ||
            r.table_name ||
            '" CASCADE CONSTRAINTS PURGE';

        DBMS_OUTPUT.PUT_LINE(
            '[OK] Dropped table: ' ||
            r.table_name
        );

    END LOOP;

END;
/

-- =============================================================================
-- Completion
-- =============================================================================

PROMPT
PROMPT ============================================================================
PROMPT APEXONE CORE MODULE UNINSTALLATION COMPLETED
PROMPT ============================================================================
PROMPT
PROMPT Core Status : REMOVED
PROMPT
PROMPT Removed objects:
PROMPT   - PKG_CORE
PROMPT   - APP_FILE_METADATA
PROMPT   - APP_INSTALL_LOG
PROMPT   - APP_SCHEMA_VERSION
PROMPT
PROMPT Dependent constraints and indexes were removed automatically
PROMPT with CASCADE CONSTRAINTS PURGE.
PROMPT
PROMPT No Core sequences were present.
PROMPT
PROMPT ============================================================================

COMMIT;

EXIT SUCCESS


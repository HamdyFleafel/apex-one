-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Component      : Build Compatibility Wrapper
-- Object Name    : BUILD_DATABASE
-- Object Type    : SQL*Plus Script
-- File           : database/build/build_database.sql
-- Purpose        : Preserve the legacy foundational-build interface without
--                  maintaining a second module orchestration path.
-- Canonical Build: database/build/build_all.sql
-- Canonical Deploy: database/deployment/install/install.sql
-- =============================================================================

SET DEFINE OFF
WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT ============================================================================
PROMPT APEXONE Foundational Database Build (Canonical Build Delegation)
PROMPT ============================================================================

@@build_all.sql

PROMPT ============================================================================
PROMPT APEXONE Foundational Database Build Completed Successfully
PROMPT ============================================================================

EXIT SUCCESS

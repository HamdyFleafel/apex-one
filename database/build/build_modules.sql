-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Component      : Enterprise Modules Build
-- Object Name    : BUILD_MODULES
-- Object Type    : SQL*Plus Script
-- File           : database/build/build_modules.sql
-- Purpose        : Canonical enterprise module build orchestration.
-- =============================================================================

SET DEFINE OFF
WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT ============================================================================
PROMPT APEXONE Enterprise Modules Build
PROMPT ============================================================================

@modules/core/install_core.sql
@modules/identity/install_identity.sql
@modules/integration/install_integration.sql
@modules/security/install_security.sql
@modules/configuration/install_configuration.sql
@modules/notification/install_notification.sql
@modules/workflow/install_workflow.sql

PROMPT ============================================================================
PROMPT APEXONE Enterprise Modules Build Completed Successfully
PROMPT ============================================================================

-- APEXONE database cleanup orchestrator.
-- Canonical lifecycle ownership is under database/deployment/lifecycle/uninstall.
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT ============================================================================
PROMPT APEXONE DATABASE CLEANUP
PROMPT ============================================================================
PROMPT

@deployment/lifecycle/uninstall/drop_modules.sql
@deployment/lifecycle/uninstall/drop_framework.sql

PROMPT Cleanup orchestration completed.

-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Configuration
-- Component      : Seed
-- Object Name    : SEED_CONFIG_GROUPS
-- File           : seed_config_groups.sql
-- Description    : Verifies configuration groups. No groups are seeded until
--                  approved configuration group definitions are available.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK ON

PROMPT ============================================================
PROMPT APEXONE - SEED CONFIGURATION GROUPS
PROMPT ============================================================

PROMPT
PROMPT [1] EXISTING CONFIGURATION GROUPS

SELECT
GROUP_CODE,
GROUP_NAME,
DESCRIPTION,
CREATED_DATE
FROM APP_CONFIG_GROUPS
ORDER BY GROUP_CODE;

PROMPT
PROMPT [2] CONFIGURATION GROUP COUNT

SELECT
COUNT(*) AS GROUP_COUNT
FROM APP_CONFIG_GROUPS;

COMMIT;

PROMPT
PROMPT ============================================================
PROMPT CONFIGURATION GROUP SEED COMPLETED
PROMPT ============================================================
PROMPT No configuration groups were inserted.
PROMPT No approved group definitions exist in the current project.
PROMPT ============================================================

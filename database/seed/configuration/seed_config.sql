SET DEFINE OFF
SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK ON

PROMPT ============================================================
PROMPT APEXONE - SEED CONFIGURATION
PROMPT ============================================================

PROMPT
PROMPT [1] EXISTING CONFIGURATION

SELECT
CONFIG_ID,
CONFIG_KEY,
CONFIG_VALUE,
CONFIG_GROUP,
DESCRIPTION,
ACTIVE_FLAG,
CREATED_DATE,
UPDATED_DATE
FROM APP_CONFIG
ORDER BY CONFIG_KEY;

PROMPT
PROMPT [2] CONFIGURATION COUNT

SELECT
COUNT(*) AS CONFIG_COUNT
FROM APP_CONFIG;

COMMIT;

PROMPT
PROMPT ============================================================
PROMPT CONFIGURATION SEED COMPLETED
PROMPT ============================================================
PROMPT No configuration rows were inserted.
PROMPT No approved configuration definitions exist in the current project.
PROMPT ============================================================

-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Core
-- Component      : Seed
-- Object Name    : SEED_SCHEMA_VERSION
-- Object Type    : SCRIPT
-- File           : seed_schema_version.sql
-- Path           : database/seed/core/seed_schema_version.sql
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development

---

-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : [hamdy.fleafel@belcofarms.com](mailto:hamdy.fleafel@belcofarms.com)
-- WhatsApp       : 0020 1010506080

---

-- Description    : Seeds the APEXONE database schema version using VERSION_NO
--                  as the logical business key. The script is idempotent and
--                  may be safely executed multiple times without creating
--                  duplicate schema-version records.

---

-- Created On     : 2026-08-07
-- Last Modified  : 2026-08-07

---

-- Change Log     :
--   2026-08-07  HF  Initial creation.
--   2026-08-07  HF  Corrected STATUS to comply with schema constraint.

---

-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK ON

PROMPT
PROMPT ============================================================
PROMPT APEXONE - SEED SCHEMA VERSION
PROMPT ============================================================

PROMPT [1] Seeding schema version 1.3.0-alpha.1

MERGE INTO APP_SCHEMA_VERSION target
USING (
SELECT
'1.3.0-alpha.1' AS VERSION_NO,
'seed_schema_version.sql' AS SCRIPT_NAME,
'APEXONE Enterprise Platform schema seed version' AS DESCRIPTION,
'SUCCESS' AS STATUS
FROM DUAL
) source
ON (
target.VERSION_NO = source.VERSION_NO
)
WHEN MATCHED THEN
UPDATE SET
target.SCRIPT_NAME = source.SCRIPT_NAME,
target.DESCRIPTION = source.DESCRIPTION,
target.STATUS = source.STATUS
WHEN NOT MATCHED THEN
INSERT (
VERSION_NO,
SCRIPT_NAME,
DESCRIPTION,
STATUS
)
VALUES (
source.VERSION_NO,
source.SCRIPT_NAME,
source.DESCRIPTION,
source.STATUS
);

COMMIT;

PROMPT
PROMPT ============================================================
PROMPT SCHEMA VERSION SEED COMPLETED
PROMPT ============================================================

PROMPT
PROMPT [SCHEMA VERSION VERIFICATION]

SELECT
VERSION_NO,
SCRIPT_NAME,
DESCRIPTION,
INSTALLED_BY,
INSTALLED_AT,
EXECUTION_TIME_MS,
STATUS,
CHECKSUM
FROM APP_SCHEMA_VERSION
WHERE VERSION_NO = '1.3.0-alpha.1';

PROMPT
PROMPT
PROMPT [SCHEMA VERSION COUNT]

SELECT
COUNT(*) AS VERSION_COUNT
FROM APP_SCHEMA_VERSION;

PROMPT
PROMPT ============================================================
PROMPT SEED SCHEMA VERSION VERIFICATION COMPLETED
PROMPT ============================================================

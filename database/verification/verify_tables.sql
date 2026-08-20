-- ============================================================
-- APEXONE Enterprise Platform
-- Database Verification
-- Tables Validation
-- ============================================================


PROMPT ==========================================
PROMPT Checking APEXONE Tables
PROMPT ==========================================


SELECT table_name
FROM user_tables
WHERE table_name IN
(
    'APP_SCHEMA_VERSION',

    'APP_USERS',

    'APP_ROLES',
    'APP_PERMISSIONS',
    'APP_ROLE_PERMISSIONS',

    'APP_CONFIG_GROUPS',
    'APP_CONFIG',

    'APP_NOTIFICATION_TEMPLATES',
    'APP_NOTIFICATIONS',

    'APP_WORKFLOW_DEFINITIONS',
    'APP_WORKFLOW_TASKS'

)
ORDER BY table_name;

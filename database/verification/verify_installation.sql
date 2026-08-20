/*====================================================================
  APEXONE Enterprise Platform
  File Name    : verify_installation.sql
  Module       : Database Verification Framework
  Purpose      : Verify installed database objects.
  Version      : 1.0.0-alpha.4
  Database     : Oracle AI Database 26ai
====================================================================*/

PROMPT ==========================================
PROMPT APEXONE DATABASE VERIFICATION
PROMPT ==========================================

SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF


PROMPT
PROMPT Checking Tables...
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


PROMPT
PROMPT Checking Packages...
PROMPT ==========================================

SELECT object_name,
       object_type,
       status
FROM user_objects
WHERE object_name IN
(
    'PKG_SECURITY',
    'PKG_CONFIGURATION',
    'PKG_NOTIFICATION',
    'PKG_WORKFLOW',
    'PKG_AUDIT'
)
ORDER BY object_name, object_type;


PROMPT
PROMPT Checking Invalid Objects...
PROMPT ==========================================

SELECT object_name,
       object_type,
       status
FROM user_objects
WHERE status <> 'VALID'
ORDER BY object_type, object_name;


PROMPT
PROMPT Checking Constraints...
PROMPT ==========================================

SELECT constraint_name,
       table_name,
       constraint_type,
       status
FROM user_constraints
WHERE table_name LIKE 'APP_%'
ORDER BY table_name, constraint_name;


PROMPT
PROMPT Checking Schema Version...
PROMPT ==========================================

SELECT *
FROM app_schema_version
ORDER BY installed_at;


PROMPT
PROMPT ==========================================
PROMPT APEXONE VERIFICATION COMPLETED
PROMPT ==========================================

EXIT SUCCESS

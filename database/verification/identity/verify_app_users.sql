-- =============================================================================
-- Project      : APEXONE Enterprise Platform
-- Module       : Identity
-- Component    : Verification
-- Object Name  : VERIFY_APP_USERS
-- Object Type  : VERIFICATION SCRIPT
-- File         : verify_app_users.sql
-- Schema       : APEXONE
-- Owner        : Hamdy Fleafel
--
-- Purpose      : Verifies all APP_USERS database objects.
--
-- Dependencies :
--   - APP_USERS
--   - PK_APP_USERS
--   - UK_APP_USERS_USERNAME
--   - UK_APP_USERS_EMAIL
--   - APP_USERS_SEQ
--   - TRG_APP_USERS_BI
--
-- Execution Order :
--   Execute after all Identity objects are created.
--
-- Created      : 2026-08-02
-- Version      : 0.2.0
--
-- Change Log
-- -----------------------------------------------------------------------------
-- Version   Date         Author            Description
-- --------  ----------   ----------------  -------------------------------
-- 0.2.0     2026-08-02   Hamdy Fleafel     Initial Version
-- =============================================================================

SET LINESIZE 200
SET PAGESIZE 100
SET FEEDBACK ON
SET VERIFY OFF

PROMPT =========================================================================
PROMPT VERIFYING APP_USERS FOUNDATION
PROMPT =========================================================================

PROMPT
PROMPT [1] TABLE
SELECT table_name
FROM user_tables
WHERE table_name = 'APP_USERS';

PROMPT
PROMPT [2] CONSTRAINTS
SELECT constraint_name,
       constraint_type,
       status
FROM user_constraints
WHERE table_name = 'APP_USERS'
ORDER BY constraint_name;

PROMPT
PROMPT [3] SEQUENCE
SELECT sequence_name
FROM user_sequences
WHERE sequence_name = 'APP_USERS_SEQ';

PROMPT
PROMPT [4] TRIGGER
SELECT trigger_name,
       status
FROM user_triggers
WHERE trigger_name = 'TRG_APP_USERS_BI';

PROMPT
PROMPT [5] TABLE COMMENT
SELECT comments
FROM user_tab_comments
WHERE table_name = 'APP_USERS';

PROMPT
PROMPT [6] COLUMN COMMENTS
SELECT column_name,
       comments
FROM user_col_comments
WHERE table_name = 'APP_USERS'
ORDER BY column_id;

PROMPT
PROMPT =========================================================================
PROMPT VERIFICATION COMPLETED
PROMPT =========================================================================
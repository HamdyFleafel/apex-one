-- =============================================================================
-- Project      : APEXONE Enterprise Platform
-- Module       : Identity
-- Component    : Core
-- Object Name  : APP_USERS_COMMENTS
-- Object Type  : COMMENTS
-- File         : app_users_comments.sql
-- Schema       : APEXONE
-- Owner        : Hamdy Fleafel
--
-- Purpose      : Creates comments for APP_USERS table and columns.
--
-- Dependencies :
--   - APP_USERS
--
-- Execution Order :
--   1. app_users.sql
--   2. app_users_pk.sql
--   3. app_users_seq.sql
--   4. trg_app_users_bi.sql
--   5. app_users_username_uk.sql
--   6. app_users_email_uk.sql
--   7. app_users_comments.sql
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

SET DEFINE OFF
SET VERIFY OFF
SET FEEDBACK ON
SET ECHO OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE

PROMPT =========================================================================
PROMPT Creating comments for APP_USERS...
PROMPT =========================================================================

COMMENT ON TABLE app_users IS
'Stores application user accounts for the APEXONE Enterprise Platform.';

COMMENT ON COLUMN app_users.user_id IS
'Primary key of the application user.';

COMMENT ON COLUMN app_users.username IS
'Unique username used for authentication.';

COMMENT ON COLUMN app_users.email IS
'Unique email address of the application user.';

COMMENT ON COLUMN app_users.display_name IS
'Display name shown throughout the application.';

COMMENT ON COLUMN app_users.password_verifier IS
'Password verifier or password hash.';

COMMENT ON COLUMN app_users.account_status_code IS
'Current account status (ACTIVE, LOCKED, DISABLED, etc.).';

COMMENT ON COLUMN app_users.failed_login_count IS
'Number of consecutive failed login attempts.';

COMMENT ON COLUMN app_users.locked_until IS
'Account lock expiration timestamp.';

COMMENT ON COLUMN app_users.last_login_at IS
'Timestamp of the last successful login.';

COMMENT ON COLUMN app_users.created_at IS
'Record creation timestamp.';

COMMENT ON COLUMN app_users.created_by IS
'User identifier who created this record.';

COMMENT ON COLUMN app_users.updated_at IS
'Last update timestamp.';

COMMENT ON COLUMN app_users.updated_by IS
'User identifier who last updated this record.';

PROMPT =========================================================================
PROMPT APP_USERS comments created successfully.
PROMPT =========================================================================
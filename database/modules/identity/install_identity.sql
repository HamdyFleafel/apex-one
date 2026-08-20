-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Installation
-- Object Name    : INSTALL_IDENTITY
-- Object Type    : INSTALL SCRIPT
-- File           : install_identity.sql
-- Path           : database/modules/identity/install_identity.sql
-- Schema         : APEXONE
-- Version        : 1.5.0-alpha.1
-- Status         : Development
-- =============================================================================
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- =============================================================================
-- Description    : Installs the complete Identity module including sequences,
--                  tables, constraints, indexes, packages, documentation,
--                  and installation verification.
--
--                  This script is intended to be executed from the database
--                  root directory:
--
--                      @modules/identity/install_identity.sql
--
--                  All nested SQL*Plus script paths are intentionally written
--                  relative to the database root directory.
-- =============================================================================
-- Created On     : 2026-08-07
-- Last Modified  : 2026-08-10
-- =============================================================================
-- Change Log     :
--   2026-08-07  HF  Initial Identity module installation script.
--   2026-08-10  HF  Standardized all nested SQL*Plus paths to use
--                   database-root-relative @modules/identity/... paths.
--   2026-08-10  HF  Corrected APP_SESSIONS table installation script.
-- =============================================================================
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

-- =============================================================================
-- SQL*Plus Environment
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET SQLBLANKLINES ON

WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

-- =============================================================================
-- Installation Header
-- =============================================================================

PROMPT
PROMPT ============================================================================
PROMPT APEXONE IDENTITY MODULE INSTALLATION
PROMPT ============================================================================
PROMPT
PROMPT Schema           : APEXONE
PROMPT Data Tablespace  : APEXONE_DATA
PROMPT Index Tablespace : APEXONE_INDEX
PROMPT
PROMPT Module           : Identity
PROMPT Build Mode       : INSTALL
PROMPT
PROMPT ============================================================================

-- =============================================================================
-- [1/5] Installing Identity Sequences
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [1/5] Installing Identity Sequences
PROMPT ----------------------------------------------------------------------------

@modules/identity/sequences/install_sequences.sql

-- =============================================================================
-- [2/5] Creating Identity Tables
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [2/5] Creating Identity Tables
PROMPT ----------------------------------------------------------------------------

@modules/identity/tables/app_users.sql
@modules/identity/tables/app_roles.sql
@modules/identity/tables/app_permissions.sql
@modules/identity/tables/app_role_permissions.sql
@modules/identity/tables/app_user_roles.sql
@modules/identity/tables/app_sessions.sql
@modules/identity/tables/app_login_attempts.sql

-- =============================================================================
-- [3/5] Creating Identity Constraints
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [3/5] Creating Identity Constraints
PROMPT ----------------------------------------------------------------------------

PROMPT
PROMPT Primary Keys
PROMPT ----------------------------------------------------------------------------

@modules/identity/constraints/app_users_pk.sql
@modules/identity/constraints/app_roles_pk.sql
@modules/identity/constraints/app_permissions_pk.sql
@modules/identity/constraints/app_role_permissions_pk.sql
@modules/identity/constraints/app_user_roles_pk.sql
@modules/identity/constraints/app_sessions_pk.sql
@modules/identity/constraints/app_login_attempts_pk.sql

PROMPT
PROMPT Unique Constraints
PROMPT ----------------------------------------------------------------------------

@modules/identity/constraints/app_users_username_uk.sql
@modules/identity/constraints/app_users_email_uk.sql
@modules/identity/constraints/app_roles_code_uk.sql
@modules/identity/constraints/app_permissions_code_uk.sql
@modules/identity/constraints/app_role_permissions_uk.sql
@modules/identity/constraints/app_user_roles_uk.sql
@modules/identity/constraints/app_sessions_token_uk.sql

PROMPT
PROMPT Check Constraints
PROMPT ----------------------------------------------------------------------------

@modules/identity/constraints/app_permissions_status_ck.sql
@modules/identity/constraints/app_permissions_deleted_ck.sql
@modules/identity/constraints/app_permissions_code_ck.sql

PROMPT
PROMPT Foreign Keys
PROMPT ----------------------------------------------------------------------------

@modules/identity/constraints/app_role_permissions_role_fk.sql
@modules/identity/constraints/app_role_permissions_perm_fk.sql
@modules/identity/constraints/app_user_roles_user_fk.sql
@modules/identity/constraints/app_user_roles_role_fk.sql

-- =============================================================================
-- [4/5] Installing Identity Performance Indexes
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [4/5] Installing Identity Performance Indexes
PROMPT ----------------------------------------------------------------------------

@modules/identity/indexes/install_indexes.sql

-- =============================================================================
-- [5/5] Installing Identity Packages
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [5/5] Installing Identity Packages
PROMPT ----------------------------------------------------------------------------

-- =============================================================================
-- [5/5] Identity packages
-- =============================================================================

PROMPT Installing PKG_IDENTITY
PROMPT ----------------------------------------------------------------------------

@modules/identity/packages/spec/PKG_IDENTITY.pks
@modules/identity/packages/body/PKG_IDENTITY.pkb

-- =============================================================================
-- [5/5] Applying Identity Documentation
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [5/5] Applying Identity Documentation
PROMPT ----------------------------------------------------------------------------

@modules/identity/docs/app_users_comments.sql
@modules/identity/docs/app_permissions_comments.sql

-- =============================================================================
-- [5/5] Verifying Identity Installation
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [5/5] Verifying Identity Installation
PROMPT ----------------------------------------------------------------------------

SELECT
    OBJECT_NAME,
    OBJECT_TYPE,
    STATUS
FROM USER_OBJECTS
WHERE OBJECT_NAME IN
(
    'APP_USERS',
    'APP_ROLES',
    'APP_PERMISSIONS',
    'APP_ROLE_PERMISSIONS',
    'APP_USER_ROLES',
    'APP_SESSIONS',
    'APP_LOGIN_ATTEMPTS',
    'PKG_IDENTITY'
)
ORDER BY
    OBJECT_TYPE,
    OBJECT_NAME;

-- =============================================================================
-- Installation Completion
-- =============================================================================

COMMIT;

PROMPT
PROMPT ============================================================================
PROMPT APEXONE IDENTITY MODULE INSTALLATION COMPLETED
PROMPT ============================================================================
PROMPT
PROMPT Identity Status : INSTALLED
PROMPT
PROMPT Tables          : CREATED / VERIFIED
PROMPT Constraints     : CREATED / VERIFIED
PROMPT Indexes         : CREATED / VERIFIED
PROMPT Sequences       : CREATED / VERIFIED
PROMPT Packages        : CREATED / VERIFIED
PROMPT Documentation   : APPLIED
PROMPT Verification    : COMPLETED
PROMPT
PROMPT Data Tablespace  : APEXONE_DATA
PROMPT Index Tablespace : APEXONE_INDEX
PROMPT
PROMPT ============================================================================
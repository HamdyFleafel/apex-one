-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Installation
-- Object Name    : install_security.sql
-- Object Type    : SQL*Plus INSTALLER
-- File           : install_security.sql
-- Path           : database/modules/security/install_security.sql
-- Schema         : APEXONE
-- Version        : 1.0.0-alpha.1
-- Status         : Development
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
--
-- Description    : Installs the Security module.
--
-- Security Layer Responsibilities:
--   - Security-specific audit and policy infrastructure.
--   - Security packages.
--   - Authorization services consuming Identity RBAC objects.
--   - Security verification.
--
-- Identity Objects:
--   APP_USERS
--   APP_USER_ROLES
--   APP_ROLES
--   APP_PERMISSIONS
--   APP_ROLE_PERMISSIONS
--
-- Identity objects are owned and created by the Identity module.
-- Security consumes these objects and does not create them.
--
-- RBAC seed data is owned by the Identity module and is therefore
-- not executed by this installer.
--
-- Created On     : 2026-08-13
-- Last Modified  : 2026-08-13
--
-- Change Log     :
--   2026-08-13  HF  Corrected Security installer paths to use
--                   database-root-relative @modules/security/... paths.
--   2026-08-13  HF  Removed Identity-owned RBAC objects from Security
--                   installation responsibilities.
--   2026-08-13  HF  Removed RBAC seed execution from Security installer.
--
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
PROMPT APEXONE SECURITY MODULE INSTALLATION
PROMPT ============================================================================
PROMPT
PROMPT Schema           : APEXONE
PROMPT Module           : Security
PROMPT Build Mode       : INSTALL
PROMPT
PROMPT Identity Objects : Managed by Identity Module
PROMPT
PROMPT ============================================================================


-- =============================================================================
-- [1] Creating Security Tables
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [1] Creating Security Tables
PROMPT ----------------------------------------------------------------------------

@modules/security/tables/app_login_history.sql
@modules/security/tables/app_password_history.sql
@modules/security/tables/app_security_audit.sql

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT Identity Objects are managed by Identity Module
PROMPT ----------------------------------------------------------------------------

PROMPT APP_USERS
PROMPT APP_USER_ROLES
PROMPT APP_ROLES
PROMPT APP_PERMISSIONS
PROMPT APP_ROLE_PERMISSIONS


-- =============================================================================
-- [2] Creating Security Sequences
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [2] Creating Security Sequences
PROMPT ----------------------------------------------------------------------------

@modules/security/sequences/SEQ_APP_SECURITY_AUDIT.sql


-- =============================================================================
-- [3] Creating Security Constraints
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [3] Creating Security Constraints
PROMPT ----------------------------------------------------------------------------

@modules/security/constraints/app_login_history_pk.sql
@modules/security/constraints/app_password_history_pk.sql
@modules/security/constraints/app_password_history_user_fk.sql
@modules/security/constraints/app_security_audit_result_ck.sql


-- =============================================================================
-- [4] Installing Security Packages
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [4] Installing Security Packages
PROMPT ----------------------------------------------------------------------------

PROMPT
PROMPT Installing PKG_SECURITY
PROMPT ----------------------------------------------------------------------------

@modules/security/packages/spec/PKG_SECURITY.pks
@modules/security/packages/body/PKG_SECURITY.pkb

PROMPT
PROMPT Installing PKG_SECURITY_POLICY
PROMPT ----------------------------------------------------------------------------

@modules/security/packages/spec/PKG_SECURITY_POLICY.pks
@modules/security/packages/body/PKG_SECURITY_POLICY.pkb

PROMPT
PROMPT Installing PKG_AUDIT
PROMPT ----------------------------------------------------------------------------

@modules/security/packages/spec/PKG_AUDIT.pks
@modules/security/packages/body/PKG_AUDIT.pkb

PROMPT
PROMPT Installing PKG_SECURITY_LOCKOUT
PROMPT ----------------------------------------------------------------------------

@modules/security/packages/spec/PKG_SECURITY_LOCKOUT.pks
@modules/security/packages/body/PKG_SECURITY_LOCKOUT.pkb

PROMPT
PROMPT Installing PKG_AUTHENTICATION
PROMPT ----------------------------------------------------------------------------

@modules/security/packages/spec/PKG_AUTHENTICATION.pks
@modules/security/packages/body/PKG_AUTHENTICATION.pkb

PROMPT
PROMPT Installing PKG_AUTHORIZATION
PROMPT ----------------------------------------------------------------------------

@modules/security/packages/spec/PKG_AUTHORIZATION.pks
@modules/security/packages/body/PKG_AUTHORIZATION.pkb


-- =============================================================================
-- [5] Security Verification
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [5] Security Installation Verification
PROMPT ----------------------------------------------------------------------------

SELECT
    OBJECT_NAME,
    OBJECT_TYPE,
    STATUS
FROM USER_OBJECTS
WHERE OBJECT_NAME IN
(
    'APP_LOGIN_HISTORY',
    'APP_PASSWORD_HISTORY',
    'APP_SECURITY_AUDIT',
    'SEQ_APP_SECURITY_AUDIT',
    'PKG_SECURITY_LOCKOUT',
    'PKG_AUTHENTICATION',
    'PKG_SECURITY',
    'PKG_SECURITY_POLICY',
    'PKG_AUDIT',
    'PKG_AUTHORIZATION'
)
ORDER BY
    OBJECT_TYPE,
    OBJECT_NAME;


-- =============================================================================
-- [6] Identity Dependency Verification
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [6] Identity Dependency Verification
PROMPT ----------------------------------------------------------------------------

SELECT
    OBJECT_NAME,
    OBJECT_TYPE,
    STATUS
FROM USER_OBJECTS
WHERE OBJECT_NAME IN
(
    'APP_USERS',
    'APP_USER_ROLES',
    'APP_ROLES',
    'APP_PERMISSIONS',
    'APP_ROLE_PERMISSIONS'
)
ORDER BY
    OBJECT_TYPE,
    OBJECT_NAME;


-- =============================================================================
-- [7] Installation Completion
-- =============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [7] Security Installation Completion
PROMPT ----------------------------------------------------------------------------

COMMIT;

PROMPT
PROMPT ============================================================================
PROMPT APEXONE SECURITY MODULE INSTALLATION COMPLETED SUCCESSFULLY
PROMPT ============================================================================
PROMPT
PROMPT Identity Objects : MANAGED BY IDENTITY MODULE
PROMPT Security Tables  : INSTALLED
PROMPT Security Sequence: INSTALLED
PROMPT Security Packages: INSTALLED
PROMPT Audit Layer      : INSTALLED
PROMPT Authorization    : INSTALLED
PROMPT Verification     : COMPLETED
PROMPT
PROMPT ============================================================================

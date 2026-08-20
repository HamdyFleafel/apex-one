-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Platform Framework
-- Component      : Module Installation
-- Object Name    : INSTALL_FRAMEWORK
-- Object Type    : SCRIPT
-- File           : install_framework.sql
-- Path           : database/platform/framework/install/install_framework.sql
-- Schema         : APEXONE
-- Version        : 2.0.0-alpha.2
-- Status         : Development
-- =============================================================================

SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK ON
SET HEADING ON
SET PAGESIZE 100
SET LINESIZE 200
SET TAB OFF
SET TRIMSPOOL ON
SET DEFINE OFF
SET SQLBLANKLINES ON

WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT
PROMPT ============================================================================
PROMPT APEXONE FRAMEWORK MODULE INSTALLATION
PROMPT ============================================================================
PROMPT
PROMPT Schema           : APEXONE
PROMPT Source Directory : database/platform/framework
PROMPT Installation Directory : database/platform/framework/install
PROMPT
PROMPT ============================================================================

PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [1/4] Installing Framework Errors Package Specification
PROMPT ----------------------------------------------------------------------------


@platform/framework/errors/spec/PKG_ERRORS.pks


PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [2/4] Installing Framework Errors Package Body
PROMPT ----------------------------------------------------------------------------


@platform/framework/errors/body/PKG_ERRORS.pkb


PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [3/4] Installing Platform Security Hash Package Specification
PROMPT ----------------------------------------------------------------------------


@platform/framework/security/spec/PKG_SECURITY_HASH.pks


PROMPT
PROMPT ----------------------------------------------------------------------------
PROMPT [4/4] Installing Platform Security Hash Package Body
PROMPT ----------------------------------------------------------------------------


@platform/framework/security/body/PKG_SECURITY_HASH.pkb

COMMIT;

PROMPT
PROMPT ============================================================================
PROMPT APEXONE FRAMEWORK MODULE INSTALLATION COMPLETED SUCCESSFULLY
PROMPT ============================================================================
PROMPT
PROMPT Framework Status : INSTALLED
PROMPT
PROMPT ============================================================================
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Installation
-- Object Name    : INSTALL_DOCS
-- Object Type    : INSTALL SCRIPT
-- File           : install_docs.sql
-- Path           : database\modules\identity\install_docs.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- -----------------------------------------------------------------------------
-- Description    : Applies comments and documentation for the Identity module.
-- =============================================================================

PROMPT =============================================================================
PROMPT Applying Identity Documentation
PROMPT =============================================================================

@modules/identity/docs/app_users_comments.sql
@modules/identity/docs/app_permissions_comments.sql

PROMPT =============================================================================
PROMPT Identity Documentation Applied Successfully
PROMPT =============================================================================
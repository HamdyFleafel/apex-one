-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Installation
-- Object Name    : INSTALL_TABLES
-- Object Type    : INSTALL SCRIPT
-- File           : install_tables.sql
-- Path           : database\modules\identity\install_tables.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- -----------------------------------------------------------------------------
-- Description    : Installs all database tables for the Identity module.
-- =============================================================================

PROMPT =============================================================================
PROMPT Installing Identity Tables
PROMPT =============================================================================

@modules/identity/tables/app_users.sql
@modules/identity/tables/app_roles.sql
@modules/identity/tables/app_permissions.sql
@modules/identity/tables/app_user_roles.sql
@modules/identity/tables/app_role_permissions.sql
@modules/identity/tables/app_login_attempts.sql
@modules/identity/tables/app_sessions.sql

PROMPT =============================================================================
PROMPT Identity Tables Installed Successfully
PROMPT =============================================================================
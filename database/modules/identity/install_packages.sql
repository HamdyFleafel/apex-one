-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Installation
-- Object Name    : INSTALL_PACKAGES
-- Object Type    : INSTALL SCRIPT
-- File           : install_packages.sql
-- Path           : database\modules\identity\install_packages.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- -----------------------------------------------------------------------------
-- Description    : Installs all PL/SQL packages for the Identity module.
-- =============================================================================

PROMPT =============================================================================
PROMPT Installing Identity Packages
PROMPT =============================================================================

PROMPT Installing Package Specifications...

@modules/identity/packages/spec/PKG_IDENTITY.pks

PROMPT Installing Package Bodies...

@modules/identity/packages/body/PKG_IDENTITY.pkb

PROMPT =============================================================================
PROMPT Identity Packages Installed Successfully
PROMPT =============================================================================

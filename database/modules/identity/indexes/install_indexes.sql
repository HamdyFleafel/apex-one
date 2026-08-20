-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Installation
-- Object Name    : INSTALL_INDEXES
-- Object Type    : SCRIPT
-- File           : install_indexes.sql
-- Path           : database\modules\identity\install_indexes.sql
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Installs non-constraint Identity indexes required for
--                  authorization lookups and account-status filtering.
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-07
-- Last Modified  : 2026-08-07
-- -----------------------------------------------------------------------------
-- Change Log     :
--   2026-08-07  HF  Standardized Identity index installation.
--   2026-08-07  HF  Removed redundant constraint-backed indexes.
--   2026-08-07  HF  Retained only performance indexes not covered by
--                  primary-key or unique-constraint indexes.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================


PROMPT ============================================================
PROMPT APEXONE - Identity Module
PROMPT Installing Identity Indexes
PROMPT ============================================================


PROMPT Creating APP_ROLE_PERMISSIONS Permission Index

@modules/identity/indexes/IDX_APP_ROLE_PERMISSIONS_PERMISSION_ID.sql


PROMPT Creating APP_USERS Status Index

@modules/identity/indexes/IDX_APP_USERS_STATUS.sql


PROMPT ============================================================
PROMPT Identity Index Installation Completed
PROMPT ============================================================
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Core
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-08
-- Last Modified  : 2026-08-08
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

-- Component      : Core Indexes
-- Object Name     : CORE_INDEXES
-- Object Type     : SCRIPT
-- Description     : Aggregator for Core standalone indexes.
-- Change Log :
-- 2026-08-08 HF Replaced placeholder with APP_FILE_METADATA indexes.
-- =============================================================================

PROMPT Creating Core Indexes

@modules/core/indexes/app_file_metadata_status_idx.sql
@modules/core/indexes/app_file_metadata_created_idx.sql

PROMPT Core indexes completed.

-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Sequences Installation
-- Object Name    : INSTALL_SEQUENCES
-- Object Type    : INSTALL SCRIPT
-- File           : install_sequences.sql
-- Path           : database/modules/identity/sequences/install_sequences.sql
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
--
-- Description    :
-- Installs all sequences required by Identity module.
-- Uses stable project-relative paths.
--
-- Created On     : 2026-08-07
-- Last Modified  : 2026-08-09
--
-- Change Log :
--   2026-08-09 HF Fixed SQL*Plus nested path resolution
--
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

SET DEFINE OFF
SET VERIFY OFF
SET FEEDBACK ON
SET SERVEROUTPUT ON

PROMPT =============================================================================
PROMPT Installing Identity Sequences
PROMPT =============================================================================


@modules/identity/sequences/SEQ_APP_USERS.sql
@modules/identity/sequences/SEQ_APP_ROLES.sql
@modules/identity/sequences/SEQ_APP_PERMISSIONS.sql
@modules/identity/sequences/SEQ_APP_USER_ROLES.sql
@modules/identity/sequences/SEQ_APP_ROLE_PERMISSIONS.sql


PROMPT =============================================================================
PROMPT Identity Sequences Installed Successfully
PROMPT =============================================================================
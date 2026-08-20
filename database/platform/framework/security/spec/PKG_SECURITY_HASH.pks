-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Platform Framework
-- Component      : Security Framework
-- Object Name    : PKG_SECURITY_HASH
-- Object Type    : PACKAGE SPECIFICATION
-- File           : PKG_SECURITY_HASH.pks
-- Path           : database/platform/framework/security/spec/PKG_SECURITY_HASH.pks
-- Schema         : APEXONE
-- Version        : 1.2.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Provides secure password hashing and verification functions
--                  using SHA-256 and random salt generation.
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-05
-- Last Modified  : 2026-08-05
-- -----------------------------------------------------------------------------
-- Change Log     :
--   2026-08-05  HF  Initial creation.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

CREATE OR REPLACE PACKAGE PKG_SECURITY_HASH
IS

    FUNCTION generate_salt
        RETURN VARCHAR2;

    FUNCTION hash_password
    (
        p_password IN VARCHAR2,
        p_salt     IN VARCHAR2
    )
    RETURN VARCHAR2;

    FUNCTION verify_password
    (
        p_password      IN VARCHAR2,
        p_stored_hash   IN VARCHAR2,
        p_stored_salt   IN VARCHAR2
    )
    RETURN BOOLEAN;

END PKG_SECURITY_HASH;
/
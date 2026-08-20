-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Platform Framework
-- Component      : Security Framework
-- Object Name    : PKG_SECURITY_HASH
-- Object Type    : PACKAGE BODY
-- File           : PKG_SECURITY_HASH.pkb
-- Path           : database/platform/framework/security/body/PKG_SECURITY_HASH.pkb
-- Schema         : APEXONE
-- Version        : 1.2.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Implements SHA-256 password hashing with secure salt.
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-05
-- Last Modified  : 2026-08-05
-- -----------------------------------------------------------------------------
-- Change Log     :
--   2026-08-05  HF  Initial creation.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

CREATE OR REPLACE PACKAGE BODY PKG_SECURITY_HASH
IS

    FUNCTION generate_salt
        RETURN VARCHAR2
    IS
        l_raw RAW(32);
    BEGIN
        l_raw := DBMS_CRYPTO.RANDOMBYTES(32);
        RETURN RAWTOHEX(l_raw);
    END;


    FUNCTION hash_password
    (
        p_password IN VARCHAR2,
        p_salt     IN VARCHAR2
    )
    RETURN VARCHAR2
    IS
        l_input RAW(32767);
        l_hash  RAW(32767);
    BEGIN
        l_input := UTL_RAW.CAST_TO_RAW(p_password || p_salt);

        l_hash := DBMS_CRYPTO.HASH
        (
            src => l_input,
            typ => DBMS_CRYPTO.HASH_SH256
        );

        RETURN RAWTOHEX(l_hash);
    END;


    FUNCTION verify_password
    (
        p_password      IN VARCHAR2,
        p_stored_hash   IN VARCHAR2,
        p_stored_salt   IN VARCHAR2
    )
    RETURN BOOLEAN
    IS
        l_new_hash VARCHAR2(4000);
    BEGIN
        l_new_hash := hash_password(p_password, p_stored_salt);

        RETURN l_new_hash = p_stored_hash;
    END;

END PKG_SECURITY_HASH;
/
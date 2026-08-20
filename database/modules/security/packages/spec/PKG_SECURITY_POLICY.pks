-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Packages
-- Object Name    : PKG_SECURITY_POLICY
-- Object Type    : PACKAGE SPECIFICATION
-- File           : PKG_SECURITY_POLICY.pks
-- Path           : database/modules/security/packages/spec/PKG_SECURITY_POLICY.pks
-- Schema         : APEXONE
-- Version        : 2.0.0-alpha.1
-- Status         : Development
-- =============================================================================

-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080

-- Description    : Enforces password complexity, expiration and password
--                  reuse policy using PKG_SECURITY_HASH.
-- =============================================================================

CREATE OR REPLACE PACKAGE PKG_SECURITY_POLICY
IS

    PROCEDURE enforce_complexity
    (
        p_password IN VARCHAR2
    );

    PROCEDURE check_expiry
    (
        p_user_id IN NUMBER
    );

    PROCEDURE change_password
    (
        p_user_id   IN NUMBER,
        p_password  IN VARCHAR2
    );

END PKG_SECURITY_POLICY;
/

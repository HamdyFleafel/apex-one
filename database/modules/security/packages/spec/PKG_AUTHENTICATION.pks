-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Authentication
-- Object Name    : PKG_AUTHENTICATION
-- Object Type    : PACKAGE SPECIFICATION
-- File           : PKG_AUTHENTICATION.pks
-- Schema         : APEXONE
-- =============================================================================

CREATE OR REPLACE PACKAGE PKG_AUTHENTICATION
IS

    FUNCTION login
    (
        p_username    IN VARCHAR2,
        p_password    IN VARCHAR2,
        p_ip_address  IN VARCHAR2,
        p_user_agent  IN VARCHAR2
    )
    RETURN NUMBER;

    FUNCTION login_with_session
    (
        p_username    IN VARCHAR2,
        p_password    IN VARCHAR2,
        p_ip_address  IN VARCHAR2,
        p_user_agent  IN VARCHAR2
    )
    RETURN VARCHAR2;

END PKG_AUTHENTICATION;
/

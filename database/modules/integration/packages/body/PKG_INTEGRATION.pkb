-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Integration
-- Component      : Packages
-- Object Name    : PKG_INTEGRATION
-- Object Type    : PACKAGE BODY
-- File           : PKG_INTEGRATION.pkb
-- Path           : database/modules/integration/packages/body/PKG_INTEGRATION.pkb
-- Schema         : APEXONE
-- Version        : 1.0.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Description    : Implementation of the thin integration boundary.
-- Created On     : 2026-08-20
-- =============================================================================

CREATE OR REPLACE PACKAGE BODY PKG_INTEGRATION
IS
    FUNCTION create_user
    (
        p_username IN VARCHAR2,
        p_email    IN VARCHAR2,
        p_password IN VARCHAR2
    )
    RETURN NUMBER
    IS
    BEGIN
        RETURN PKG_IDENTITY.CREATE_USER
        (
            p_username => p_username,
            p_email    => p_email,
            p_password => p_password
        );
    END create_user;
END PKG_INTEGRATION;
/

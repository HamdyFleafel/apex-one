-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Integration
-- Component      : Packages
-- Object Name    : PKG_INTEGRATION
-- Object Type    : PACKAGE SPECIFICATION
-- File           : PKG_INTEGRATION.pks
-- Path           : database/modules/integration/packages/spec/PKG_INTEGRATION.pks
-- Schema         : APEXONE
-- Version        : 1.0.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Description    : Thin integration boundary for external transports.
-- Created On     : 2026-08-20
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

CREATE OR REPLACE PACKAGE PKG_INTEGRATION
IS
    -- Delegates user creation to the authoritative Identity service.
    -- Identity validation, security and persistence remain outside this package.
    FUNCTION create_user
    (
        p_username IN VARCHAR2,
        p_email    IN VARCHAR2,
        p_password IN VARCHAR2
    )
    RETURN NUMBER;
END PKG_INTEGRATION;
/

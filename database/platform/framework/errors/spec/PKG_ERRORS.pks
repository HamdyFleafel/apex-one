-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Framework
-- Component      : Packages
-- Object Name    : PKG_ERRORS
-- Object Type    : PACKAGE SPECIFICATION
-- File           : PKG_ERRORS.pks
-- Path           : database/platform/framework/errors/spec/PKG_ERRORS.pks
-- Schema         : APEXONE
-- Version        : 2.0.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Centralized enterprise error handling framework.
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-05
-- Last Modified  : 2026-08-05
-- -----------------------------------------------------------------------------
-- Change Log     :
--   2026-08-05  HF  Initial creation.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

CREATE OR REPLACE PACKAGE PKG_ERRORS
IS

    ----------------------------------------------------------------------------
    -- Generic Raise
    ----------------------------------------------------------------------------
    PROCEDURE raise_error
    (
        p_code      IN NUMBER,
        p_message   IN VARCHAR2
    );

    ----------------------------------------------------------------------------
    -- Security Error
    ----------------------------------------------------------------------------
    PROCEDURE raise_security_error
    (
        p_message IN VARCHAR2
    );

    ----------------------------------------------------------------------------
    -- Identity Error
    ----------------------------------------------------------------------------
    PROCEDURE raise_identity_error
    (
        p_message IN VARCHAR2
    );

END PKG_ERRORS;
/
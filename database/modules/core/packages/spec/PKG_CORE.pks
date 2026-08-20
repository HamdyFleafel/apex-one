-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Core
-- Component      : Packages
-- Object Name    : PKG_CORE
-- Object Type    : PACKAGE SPECIFICATION
-- File           : PKG_CORE.pks
-- Path           : database/modules/core/packages/spec/PKG_CORE.pks
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Core installation and version management framework.
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-05
-- Last Modified  : 2026-08-05
-- -----------------------------------------------------------------------------
-- Change Log     :
--   2026-08-05  HF  Initial creation.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

CREATE OR REPLACE PACKAGE PKG_CORE
IS

    FUNCTION install_start
    (
        p_module_name    IN VARCHAR2,
        p_module_version IN VARCHAR2
    )
    RETURN NUMBER;

    PROCEDURE install_success
    (
        p_install_id IN NUMBER
    );

    PROCEDURE install_failure
    (
        p_install_id IN NUMBER,
        p_error_msg  IN VARCHAR2
    );

END PKG_CORE;
/
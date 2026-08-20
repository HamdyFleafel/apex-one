-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Framework
-- Component      : Packages
-- Object Name    : PKG_ERRORS
-- Object Type    : PACKAGE BODY
-- File           : PKG_ERRORS.pkb
-- Path           : database/platform/framework/errors/body/PKG_ERRORS.pkb
-- Schema         : APEXONE
-- Version        : 2.0.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Implements centralized enterprise error handling.
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-05
-- Last Modified  : 2026-08-20
-- -----------------------------------------------------------------------------
-- Change Log     :
--   2026-08-05  HF  Initial creation.
--   2026-08-20  HF  Reconciled semantic error classes to valid Oracle application error codes.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

CREATE OR REPLACE PACKAGE BODY PKG_ERRORS
IS

    ----------------------------------------------------------------------------
   PROCEDURE RAISE_ERROR
(
    P_CODE      IN NUMBER,
    P_MESSAGE   IN VARCHAR2
)
IS
    L_ERROR_CODE NUMBER;
BEGIN

    IF P_CODE BETWEEN -20999 AND -20000 THEN
        L_ERROR_CODE := P_CODE;
    ELSE
        L_ERROR_CODE := -20000;
    END IF;

    RAISE_APPLICATION_ERROR
    (
        L_ERROR_CODE,
        '[' || P_CODE || '] ' || P_MESSAGE
    );

END RAISE_ERROR;


    ----------------------------------------------------------------------------
    PROCEDURE raise_security_error
    (
        p_message IN VARCHAR2
    )
    IS
    BEGIN
        raise_error(-20002, 'SECURITY_ERROR: ' || p_message);
    END;


    ----------------------------------------------------------------------------
    PROCEDURE raise_identity_error
    (
        p_message IN VARCHAR2
    )
    IS
    BEGIN
        raise_error(-20001, 'IDENTITY_ERROR: ' || p_message);
    END;

END PKG_ERRORS;
/
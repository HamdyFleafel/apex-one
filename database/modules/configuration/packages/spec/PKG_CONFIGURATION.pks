-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Configuration Framework
-- Component      : Package Specification
-- Object Name    : PKG_CONFIGURATION
-- Object Type    : PACKAGE SPEC
-- File           : PKG_CONFIGURATION.pks
-- Schema         : APEXONE
-- Description    : Configuration management package specification.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.3
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating PACKAGE PKG_CONFIGURATION
PROMPT ============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF

CREATE OR REPLACE PACKAGE PKG_CONFIGURATION
AS

    FUNCTION GET_VALUE
    (
        P_KEY VARCHAR2
    )
    RETURN VARCHAR2;

    PROCEDURE SET_VALUE
    (
        P_KEY   VARCHAR2,
        P_VALUE VARCHAR2
    );

END PKG_CONFIGURATION;
/

SHOW ERRORS

PROMPT Completed.
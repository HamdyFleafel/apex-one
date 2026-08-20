-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Configuration Framework
-- Component      : Package Body
-- Object Name    : PKG_CONFIGURATION
-- Object Type    : PACKAGE BODY
-- File           : PKG_CONFIGURATION.pkb
-- Schema         : APEXONE
-- Description    : Configuration management package body.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.3
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating PACKAGE BODY PKG_CONFIGURATION
PROMPT ============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF

CREATE OR REPLACE PACKAGE BODY PKG_CONFIGURATION
AS

    FUNCTION GET_VALUE
    (
        P_KEY VARCHAR2
    )
    RETURN VARCHAR2
    IS
        L_VALUE VARCHAR2(4000);
    BEGIN
        SELECT MAX(CONFIG_VALUE)
          INTO L_VALUE
          FROM APP_CONFIG
         WHERE CONFIG_KEY = P_KEY
           AND ACTIVE_FLAG = 'Y';

        RETURN L_VALUE;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END GET_VALUE;

    PROCEDURE SET_VALUE
    (
        P_KEY   VARCHAR2,
        P_VALUE VARCHAR2
    )
    IS
    BEGIN

        MERGE INTO APP_CONFIG C
        USING
        (
            SELECT
                P_KEY   AS KEY_VALUE,
                P_VALUE AS VAL_VALUE
            FROM DUAL
        ) X
        ON
        (
            C.CONFIG_KEY = X.KEY_VALUE
        )
        WHEN MATCHED THEN
            UPDATE SET
                C.CONFIG_VALUE = X.VAL_VALUE,
                C.UPDATED_DATE = SYSTIMESTAMP
        WHEN NOT MATCHED THEN
            INSERT
            (
                CONFIG_KEY,
                CONFIG_VALUE
            )
            VALUES
            (
                X.KEY_VALUE,
                X.VAL_VALUE
            );

    END SET_VALUE;

END PKG_CONFIGURATION;
/

SHOW ERRORS

PROMPT Completed.
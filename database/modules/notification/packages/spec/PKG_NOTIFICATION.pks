-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Notification Framework
-- Component      : Package Specification
-- Object Name    : PKG_NOTIFICATION
-- Object Type    : PACKAGE SPEC
-- File           : PKG_NOTIFICATION.pks
-- Schema         : APEXONE
-- Description    : Notification management package specification.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.4
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating PACKAGE PKG_NOTIFICATION
PROMPT ============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF

CREATE OR REPLACE PACKAGE PKG_NOTIFICATION
AS

    PROCEDURE CREATE_NOTIFICATION
    (
        P_TEMPLATE_ID NUMBER,
        P_RECIPIENT   VARCHAR2,
        P_MESSAGE      CLOB
    );

    PROCEDURE MARK_SENT
    (
        P_NOTIFICATION_ID NUMBER
    );

END PKG_NOTIFICATION;
/

SHOW ERRORS

PROMPT Completed.
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Notification Framework
-- Component      : Package Body
-- Object Name    : PKG_NOTIFICATION
-- Object Type    : PACKAGE BODY
-- File           : PKG_NOTIFICATION.pkb
-- Schema         : APEXONE
-- Description    : Notification management package body.
-- Author         : Hamdy Fleafel
-- Version        : 1.0.0-alpha.4
-- =============================================================================

PROMPT ============================================================================
PROMPT Creating PACKAGE BODY PKG_NOTIFICATION
PROMPT ============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF

CREATE OR REPLACE PACKAGE BODY PKG_NOTIFICATION
AS

    PROCEDURE CREATE_NOTIFICATION
    (
        P_TEMPLATE_ID NUMBER,
        P_RECIPIENT   VARCHAR2,
        P_MESSAGE      CLOB
    )
    IS
    BEGIN
        INSERT INTO APP_NOTIFICATIONS
        (
            TEMPLATE_ID,
            RECIPIENT,
            MESSAGE_BODY,
            NOTIFICATION_STATUS,
            CREATED_DATE
        )
        VALUES
        (
            P_TEMPLATE_ID,
            P_RECIPIENT,
            P_MESSAGE,
            'NEW',
            SYSTIMESTAMP
        );
    END CREATE_NOTIFICATION;

    PROCEDURE MARK_SENT
    (
        P_NOTIFICATION_ID NUMBER
    )
    IS
    BEGIN
        UPDATE APP_NOTIFICATIONS
        SET
            NOTIFICATION_STATUS='SENT',
            SENT_DATE=SYSTIMESTAMP
        WHERE NOTIFICATION_ID=P_NOTIFICATION_ID;
    END MARK_SENT;

END PKG_NOTIFICATION;
/

SHOW ERRORS

PROMPT Completed.
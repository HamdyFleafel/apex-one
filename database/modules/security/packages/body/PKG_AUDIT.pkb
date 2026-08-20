-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Packages
-- Object Name    : PKG_AUDIT
-- Object Type    : PACKAGE BODY
-- File           : PKG_AUDIT.pkb
-- Path           : database/modules/security/packages/body/PKG_AUDIT.pkb
-- Schema         : APEXONE
-- Version        : 1.8.0-alpha.2
-- Status         : Development
--
-- Description    : Implements centralized security audit event logging.
--
-- Transaction Contract:
--   Audit persistence is autonomous and committed independently from the
--   caller transaction. This preserves security evidence when the caller
--   subsequently rolls back or raises an exception.
--
-- Result Contract:
--   SUCCESS / FAILURE / DENIED
--
-- =============================================================================

CREATE OR REPLACE PACKAGE BODY PKG_AUDIT
IS
    PROCEDURE LOG_EVENT
    (
        P_EVENT_TYPE    IN VARCHAR2,
        P_RESULT        IN VARCHAR2,
        P_USER_ID       IN NUMBER DEFAULT NULL,
        P_USERNAME      IN VARCHAR2 DEFAULT NULL,
        P_SESSION_ID    IN VARCHAR2 DEFAULT NULL,
        P_IP_ADDRESS    IN VARCHAR2 DEFAULT NULL,
        P_OBJECT_TYPE   IN VARCHAR2 DEFAULT NULL,
        P_OBJECT_ID     IN VARCHAR2 DEFAULT NULL,
        P_ACTION        IN VARCHAR2 DEFAULT NULL,
        P_ERROR_CODE    IN VARCHAR2 DEFAULT NULL,
        P_ERROR_MESSAGE IN VARCHAR2 DEFAULT NULL
    )
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;

        L_RESULT VARCHAR2(30);
    BEGIN
        L_RESULT := UPPER(TRIM(P_RESULT));

        IF L_RESULT NOT IN ('SUCCESS', 'FAILURE', 'DENIED') THEN
            RAISE_APPLICATION_ERROR(
                -20001,
                'Invalid audit result.'
            );
        END IF;

        INSERT INTO APP_SECURITY_AUDIT
        (
            AUDIT_ID,
            EVENT_TYPE,
            EVENT_TIME,
            USER_ID,
            USERNAME,
            SESSION_ID,
            IP_ADDRESS,
            OBJECT_TYPE,
            OBJECT_ID,
            ACTION,
            RESULT,
            ERROR_CODE,
            ERROR_MESSAGE
        )
        VALUES
        (
            SEQ_APP_SECURITY_AUDIT.NEXTVAL,
            P_EVENT_TYPE,
            SYSTIMESTAMP,
            P_USER_ID,
            P_USERNAME,
            P_SESSION_ID,
            P_IP_ADDRESS,
            P_OBJECT_TYPE,
            P_OBJECT_ID,
            P_ACTION,
            L_RESULT,
            P_ERROR_CODE,
            P_ERROR_MESSAGE
        );

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END LOG_EVENT;

END PKG_AUDIT;
/

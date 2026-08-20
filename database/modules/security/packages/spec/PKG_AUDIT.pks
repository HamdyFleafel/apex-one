-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Packages
-- Object Name    : PKG_AUDIT
-- Object Type    : PACKAGE
-- File           : PKG_AUDIT.pks
-- Path           : database/modules/security/packages/spec/PKG_AUDIT.pks
-- Schema         : APEXONE
-- Version        : 1.8.0-alpha.2
-- Status         : Development
--
-- Description    : Defines the public interface for centralized security
--                  audit event logging.
--
-- Transaction Contract:
--   The implementation persists audit events in an autonomous transaction
--   so audit evidence survives rollback of the caller transaction.
--
-- Result Contract:
--   SUCCESS / FAILURE / DENIED
--
-- =============================================================================

CREATE OR REPLACE PACKAGE PKG_AUDIT
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
    );
END PKG_AUDIT;
/

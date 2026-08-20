-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Authentication
-- Object Name    : PKG_AUTHENTICATION
-- Object Type    : PACKAGE BODY
-- File           : PKG_AUTHENTICATION.pkb
-- Path           : database/modules/security/packages/body/PKG_AUTHENTICATION.pkb
-- Schema         : APEXONE
-- Version        : 2.0.0-alpha.1
-- Status         : Development
-- =============================================================================
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- Description    : Authentication engine for APP_USERS.
--                  Password verification is delegated to PKG_SECURITY_HASH.
--                  Security events are written through PKG_AUDIT.
-- =============================================================================
CREATE OR REPLACE PACKAGE BODY PKG_AUTHENTICATION
IS

FUNCTION LOGIN
(
    P_USERNAME IN VARCHAR2,
    P_PASSWORD IN VARCHAR2,
    P_IP_ADDRESS IN VARCHAR2,
    P_USER_AGENT IN VARCHAR2
)
RETURN NUMBER
IS
    L_USER_ID APP_USERS.USER_ID%TYPE;
    L_VERIFIER APP_USERS.PASSWORD_VERIFIER%TYPE;
    L_SALT APP_USERS.PASSWORD_SALT%TYPE;
    L_STATUS APP_USERS.ACCOUNT_STATUS_CODE%TYPE;
    L_FORCE_PASSWORD_RESET APP_USERS.FORCE_PASSWORD_RESET%TYPE;
    L_LOCKED_UNTIL APP_USERS.LOCKED_UNTIL%TYPE;
    L_FAILED_LOGIN_COUNT APP_USERS.FAILED_LOGIN_COUNT%TYPE;
    L_SESSION_ID VARCHAR2(400);
    L_AUDIT_ERROR_CODE VARCHAR2(100);
    L_AUDIT_ERROR_MESSAGE VARCHAR2(2000);
BEGIN

    L_SESSION_ID:=SYS_CONTEXT('USERENV','SESSIONID');

    SELECT
        USER_ID,
        PASSWORD_VERIFIER,
        PASSWORD_SALT,
        ACCOUNT_STATUS_CODE,
        FORCE_PASSWORD_RESET,
        LOCKED_UNTIL,
        FAILED_LOGIN_COUNT
    INTO
        L_USER_ID,
        L_VERIFIER,
        L_SALT,
        L_STATUS,
        L_FORCE_PASSWORD_RESET,
        L_LOCKED_UNTIL,
        L_FAILED_LOGIN_COUNT
    FROM APP_USERS
    WHERE USERNAME=UPPER(TRIM(P_USERNAME));

    IF L_STATUS<>'ACTIVE' THEN

        PKG_AUDIT.LOG_EVENT(
            P_EVENT_TYPE=>'LOGIN',
            P_RESULT=>'DENIED',
            P_USER_ID=>L_USER_ID,
            P_USERNAME=>UPPER(TRIM(P_USERNAME)),
            P_SESSION_ID=>L_SESSION_ID,
            P_IP_ADDRESS=>P_IP_ADDRESS,
            P_OBJECT_TYPE=>'AUTHENTICATION',
            P_OBJECT_ID=>TO_CHAR(L_USER_ID),
            P_ACTION=>'ACCOUNT_NOT_ACTIVE',
            P_ERROR_CODE=>'-22000',
            P_ERROR_MESSAGE=>'Account not active.'
        );

        PKG_ERRORS.RAISE_SECURITY_ERROR('Account not active.');

    END IF;

    IF L_LOCKED_UNTIL IS NOT NULL
       AND L_LOCKED_UNTIL>SYSTIMESTAMP
    THEN

        PKG_AUDIT.LOG_EVENT(
            P_EVENT_TYPE=>'LOGIN',
            P_RESULT=>'DENIED',
            P_USER_ID=>L_USER_ID,
            P_USERNAME=>UPPER(TRIM(P_USERNAME)),
            P_SESSION_ID=>L_SESSION_ID,
            P_IP_ADDRESS=>P_IP_ADDRESS,
            P_OBJECT_TYPE=>'AUTHENTICATION',
            P_OBJECT_ID=>TO_CHAR(L_USER_ID),
            P_ACTION=>'ACCOUNT_LOCKED',
            P_ERROR_CODE=>'-22000',
            P_ERROR_MESSAGE=>'Account is temporarily locked.'
        );

        PKG_ERRORS.RAISE_SECURITY_ERROR('Invalid credentials.');

    END IF;

    IF PKG_SECURITY_HASH.VERIFY_PASSWORD(
        P_PASSWORD=>P_PASSWORD,
        P_STORED_HASH=>L_VERIFIER,
        P_STORED_SALT=>L_SALT
    )
    THEN

        IF NVL(L_FORCE_PASSWORD_RESET,'N')='Y' THEN

            PKG_AUDIT.LOG_EVENT(
                P_EVENT_TYPE=>'LOGIN',
                P_RESULT=>'DENIED',
                P_USER_ID=>L_USER_ID,
                P_USERNAME=>UPPER(TRIM(P_USERNAME)),
                P_SESSION_ID=>L_SESSION_ID,
                P_IP_ADDRESS=>P_IP_ADDRESS,
                P_OBJECT_TYPE=>'AUTHENTICATION',
                P_OBJECT_ID=>TO_CHAR(L_USER_ID),
                P_ACTION=>'PASSWORD_RESET_REQUIRED',
                P_ERROR_CODE=>'-22000',
                P_ERROR_MESSAGE=>'Password reset required.'
            );

            PKG_ERRORS.RAISE_SECURITY_ERROR('Password reset required.');

        END IF;

        BEGIN

            PKG_SECURITY_POLICY.CHECK_EXPIRY(
                P_USER_ID=>L_USER_ID
            );

        EXCEPTION
            WHEN OTHERS THEN

                L_AUDIT_ERROR_CODE:=TO_CHAR(SQLCODE);
                L_AUDIT_ERROR_MESSAGE:=SQLERRM;

                IF SQLCODE=-20110 THEN

                    PKG_AUDIT.LOG_EVENT(
                        P_EVENT_TYPE=>'LOGIN',
                        P_RESULT=>'DENIED',
                        P_USER_ID=>L_USER_ID,
                        P_USERNAME=>UPPER(TRIM(P_USERNAME)),
                        P_SESSION_ID=>L_SESSION_ID,
                        P_IP_ADDRESS=>P_IP_ADDRESS,
                        P_OBJECT_TYPE=>'AUTHENTICATION',
                        P_OBJECT_ID=>TO_CHAR(L_USER_ID),
                        P_ACTION=>'PASSWORD_EXPIRED',
                        P_ERROR_CODE=>L_AUDIT_ERROR_CODE,
                        P_ERROR_MESSAGE=>L_AUDIT_ERROR_MESSAGE
                    );

                ELSE

                    PKG_AUDIT.LOG_EVENT(
                        P_EVENT_TYPE=>'LOGIN',
                        P_RESULT=>'DENIED',
                        P_USER_ID=>L_USER_ID,
                        P_USERNAME=>UPPER(TRIM(P_USERNAME)),
                        P_SESSION_ID=>L_SESSION_ID,
                        P_IP_ADDRESS=>P_IP_ADDRESS,
                        P_OBJECT_TYPE=>'AUTHENTICATION',
                        P_OBJECT_ID=>TO_CHAR(L_USER_ID),
                        P_ACTION=>'PASSWORD_POLICY_ERROR',
                        P_ERROR_CODE=>L_AUDIT_ERROR_CODE,
                        P_ERROR_MESSAGE=>L_AUDIT_ERROR_MESSAGE
                    );

                END IF;

                RAISE;

        END;

        UPDATE APP_USERS
        SET
            FAILED_LOGIN_COUNT=0,
            LOCKED_UNTIL=NULL,
            LAST_LOGIN_AT=SYSTIMESTAMP,
            UPDATED_AT=SYSTIMESTAMP,
            UPDATED_BY=USER
        WHERE USER_ID=L_USER_ID;

        PKG_AUDIT.LOG_EVENT(
            P_EVENT_TYPE=>'LOGIN',
            P_RESULT=>'SUCCESS',
            P_USER_ID=>L_USER_ID,
            P_USERNAME=>UPPER(TRIM(P_USERNAME)),
            P_SESSION_ID=>L_SESSION_ID,
            P_IP_ADDRESS=>P_IP_ADDRESS,
            P_OBJECT_TYPE=>'AUTHENTICATION',
            P_OBJECT_ID=>TO_CHAR(L_USER_ID),
            P_ACTION=>'LOGIN_SUCCESS',
            P_ERROR_CODE=>NULL,
            P_ERROR_MESSAGE=>NULL
        );

        RETURN L_USER_ID;

    ELSE

        PKG_SECURITY_LOCKOUT.REGISTER_FAILURE(
            P_USER_ID=>L_USER_ID
        );

        IF NVL(L_FAILED_LOGIN_COUNT,0)+1>=5 THEN

            PKG_AUDIT.LOG_EVENT(
                P_EVENT_TYPE=>'LOGIN',
                P_RESULT=>'DENIED',
                P_USER_ID=>L_USER_ID,
                P_USERNAME=>UPPER(TRIM(P_USERNAME)),
                P_SESSION_ID=>L_SESSION_ID,
                P_IP_ADDRESS=>P_IP_ADDRESS,
                P_OBJECT_TYPE=>'AUTHENTICATION',
                P_OBJECT_ID=>TO_CHAR(L_USER_ID),
                P_ACTION=>'ACCOUNT_LOCKED',
                P_ERROR_CODE=>'-22000',
                P_ERROR_MESSAGE=>'Maximum failed login attempts reached.'
            );

        ELSE

            PKG_AUDIT.LOG_EVENT(
                P_EVENT_TYPE=>'LOGIN',
                P_RESULT=>'FAILURE',
                P_USER_ID=>L_USER_ID,
                P_USERNAME=>UPPER(TRIM(P_USERNAME)),
                P_SESSION_ID=>L_SESSION_ID,
                P_IP_ADDRESS=>P_IP_ADDRESS,
                P_OBJECT_TYPE=>'AUTHENTICATION',
                P_OBJECT_ID=>TO_CHAR(L_USER_ID),
                P_ACTION=>'LOGIN_FAILURE',
                P_ERROR_CODE=>'-22000',
                P_ERROR_MESSAGE=>'Invalid credentials.'
            );

        END IF;

        PKG_ERRORS.RAISE_SECURITY_ERROR('Invalid credentials.');

    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN

        PKG_AUDIT.LOG_EVENT(
            P_EVENT_TYPE=>'LOGIN',
            P_RESULT=>'FAILURE',
            P_USER_ID=>NULL,
            P_USERNAME=>UPPER(TRIM(P_USERNAME)),
            P_SESSION_ID=>L_SESSION_ID,
            P_IP_ADDRESS=>P_IP_ADDRESS,
            P_OBJECT_TYPE=>'AUTHENTICATION',
            P_OBJECT_ID=>NULL,
            P_ACTION=>'LOGIN_FAILURE',
            P_ERROR_CODE=>'-22000',
            P_ERROR_MESSAGE=>'Invalid credentials.'
        );

        PKG_ERRORS.RAISE_SECURITY_ERROR('Invalid credentials.');

        RETURN NULL;

END LOGIN;

END PKG_AUTHENTICATION;
/

-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Authorization
-- Object Name    : PKG_AUTHORIZATION
-- Object Type    : PACKAGE BODY
-- File           : PKG_AUTHORIZATION.pkb
-- Path           : database/modules/security/packages/body/PKG_AUTHORIZATION.pkb
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- =============================================================================
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : +20 1010506080
--
-- Description    : Authorization engine for the APEXONE RBAC model.
--
--                  Authorization is resolved through:
--
--                  APP_USER_ROLES
--                       ->
--                  APP_ROLE_PERMISSIONS
--                       ->
--                  APP_PERMISSIONS
--
--                  Authentication is handled separately by
--                  PKG_AUTHENTICATION.
--
--                  Authorization failures are centrally audited
--                  through PKG_AUDIT.
-- =============================================================================

CREATE OR REPLACE PACKAGE BODY PKG_AUTHORIZATION
IS

    FUNCTION HAS_PERMISSION
    (
        P_USER_ID         IN NUMBER,
        P_PERMISSION_CODE IN VARCHAR2
    )
    RETURN BOOLEAN
    IS
        L_COUNT NUMBER := 0;
    BEGIN

        IF P_USER_ID IS NULL
           OR P_PERMISSION_CODE IS NULL
        THEN
            RETURN FALSE;
        END IF;

        SELECT COUNT(*)
        INTO L_COUNT
        FROM APP_USER_ROLES UR
        JOIN APP_ROLE_PERMISSIONS RP
          ON RP.ROLE_ID = UR.ROLE_ID
        JOIN APP_PERMISSIONS P
          ON P.PERMISSION_ID = RP.PERMISSION_ID
        WHERE UR.USER_ID = P_USER_ID
          AND P.PERMISSION_CODE = UPPER(TRIM(P_PERMISSION_CODE))
          AND P.STATUS = 'ACTIVE'
          AND P.IS_DELETED = 'N';

        RETURN L_COUNT > 0;

    END HAS_PERMISSION;


    FUNCTION HAS_ANY_PERMISSION
    (
        P_USER_ID          IN NUMBER,
        P_PERMISSION_CODES IN VARCHAR2
    )
    RETURN BOOLEAN
    IS
        L_CODE VARCHAR2(4000);
        L_POS  PLS_INTEGER := 1;
    BEGIN

        IF P_USER_ID IS NULL
           OR P_PERMISSION_CODES IS NULL
        THEN
            RETURN FALSE;
        END IF;

        LOOP

            L_CODE := REGEXP_SUBSTR(
                P_PERMISSION_CODES,
                '[^,]+',
                1,
                L_POS
            );

            EXIT WHEN L_CODE IS NULL;

            IF HAS_PERMISSION(
                P_USER_ID         => P_USER_ID,
                P_PERMISSION_CODE => TRIM(L_CODE)
            )
            THEN
                RETURN TRUE;
            END IF;

            L_POS := L_POS + 1;

        END LOOP;

        RETURN FALSE;

    END HAS_ANY_PERMISSION;


    FUNCTION HAS_ALL_PERMISSIONS
    (
        P_USER_ID          IN NUMBER,
        P_PERMISSION_CODES IN VARCHAR2
    )
    RETURN BOOLEAN
    IS
        L_CODE VARCHAR2(4000);
        L_POS  PLS_INTEGER := 1;
    BEGIN

        IF P_USER_ID IS NULL
           OR P_PERMISSION_CODES IS NULL
        THEN
            RETURN FALSE;
        END IF;

        LOOP

            L_CODE := REGEXP_SUBSTR(
                P_PERMISSION_CODES,
                '[^,]+',
                1,
                L_POS
            );

            EXIT WHEN L_CODE IS NULL;

            IF NOT HAS_PERMISSION(
                P_USER_ID         => P_USER_ID,
                P_PERMISSION_CODE => TRIM(L_CODE)
            )
            THEN
                RETURN FALSE;
            END IF;

            L_POS := L_POS + 1;

        END LOOP;

        RETURN TRUE;

    END HAS_ALL_PERMISSIONS;


    PROCEDURE REQUIRE_PERMISSION
    (
        P_USER_ID         IN NUMBER,
        P_PERMISSION_CODE IN VARCHAR2
    )
    IS
        L_USERNAME   APP_USERS.USERNAME%TYPE;
        L_SESSION_ID VARCHAR2(400);
    BEGIN

        IF HAS_PERMISSION(
            P_USER_ID         => P_USER_ID,
            P_PERMISSION_CODE => P_PERMISSION_CODE
        )
        THEN
            RETURN;
        END IF;

        BEGIN

            SELECT USERNAME
            INTO L_USERNAME
            FROM APP_USERS
            WHERE USER_ID = P_USER_ID;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                L_USERNAME := NULL;
        END;

        L_SESSION_ID := SYS_CONTEXT(
            'USERENV',
            'SESSIONID'
        );

        PKG_AUDIT.LOG_EVENT(
            P_EVENT_TYPE    => 'AUTHORIZATION',
            P_RESULT        => 'DENIED',
            P_USER_ID       => P_USER_ID,
            P_USERNAME      => L_USERNAME,
            P_SESSION_ID    => L_SESSION_ID,
            P_OBJECT_TYPE   => 'PERMISSION',
            P_OBJECT_ID     => NULL,
            P_ACTION        => 'PERMISSION_DENIED',
            P_ERROR_CODE    => '-20200',
            P_ERROR_MESSAGE => 'Required permission denied: '
                               || UPPER(TRIM(P_PERMISSION_CODE))
        );

        PKG_ERRORS.RAISE_SECURITY_ERROR(
            'Authorization failed.'
        );

    END REQUIRE_PERMISSION;


    PROCEDURE REQUIRE_ANY_PERMISSION
    (
        P_USER_ID          IN NUMBER,
        P_PERMISSION_CODES IN VARCHAR2
    )
    IS
        L_USERNAME   APP_USERS.USERNAME%TYPE;
        L_SESSION_ID VARCHAR2(400);
    BEGIN

        IF HAS_ANY_PERMISSION(
            P_USER_ID          => P_USER_ID,
            P_PERMISSION_CODES => P_PERMISSION_CODES
        )
        THEN
            RETURN;
        END IF;

        BEGIN

            SELECT USERNAME
            INTO L_USERNAME
            FROM APP_USERS
            WHERE USER_ID = P_USER_ID;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                L_USERNAME := NULL;
        END;

        L_SESSION_ID := SYS_CONTEXT(
            'USERENV',
            'SESSIONID'
        );

        PKG_AUDIT.LOG_EVENT(
            P_EVENT_TYPE    => 'AUTHORIZATION',
            P_RESULT        => 'DENIED',
            P_USER_ID       => P_USER_ID,
            P_USERNAME      => L_USERNAME,
            P_SESSION_ID    => L_SESSION_ID,
            P_OBJECT_TYPE   => 'PERMISSION',
            P_OBJECT_ID     => NULL,
            P_ACTION        => 'ANY_PERMISSION_DENIED',
            P_ERROR_CODE    => '-20200',
            P_ERROR_MESSAGE => 'None of the required permissions granted: '
                               || P_PERMISSION_CODES
        );

        PKG_ERRORS.RAISE_SECURITY_ERROR(
            'Authorization failed.'
        );

    END REQUIRE_ANY_PERMISSION;


    PROCEDURE REQUIRE_ALL_PERMISSIONS
    (
        P_USER_ID          IN NUMBER,
        P_PERMISSION_CODES IN VARCHAR2
    )
    IS
        L_USERNAME   APP_USERS.USERNAME%TYPE;
        L_SESSION_ID VARCHAR2(400);
    BEGIN

        IF HAS_ALL_PERMISSIONS(
            P_USER_ID          => P_USER_ID,
            P_PERMISSION_CODES => P_PERMISSION_CODES
        )
        THEN
            RETURN;
        END IF;

        BEGIN

            SELECT USERNAME
            INTO L_USERNAME
            FROM APP_USERS
            WHERE USER_ID = P_USER_ID;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                L_USERNAME := NULL;
        END;

        L_SESSION_ID := SYS_CONTEXT(
            'USERENV',
            'SESSIONID'
        );

        PKG_AUDIT.LOG_EVENT(
            P_EVENT_TYPE    => 'AUTHORIZATION',
            P_RESULT        => 'DENIED',
            P_USER_ID       => P_USER_ID,
            P_USERNAME      => L_USERNAME,
            P_SESSION_ID    => L_SESSION_ID,
            P_OBJECT_TYPE   => 'PERMISSION',
            P_OBJECT_ID     => NULL,
            P_ACTION        => 'ALL_PERMISSIONS_DENIED',
            P_ERROR_CODE    => '-20200',
            P_ERROR_MESSAGE => 'Not all required permissions granted: '
                               || P_PERMISSION_CODES
        );

        PKG_ERRORS.RAISE_SECURITY_ERROR(
            'Authorization failed.'
        );

    END REQUIRE_ALL_PERMISSIONS;


END PKG_AUTHORIZATION;
/
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Lockout
-- Object Name    : PKG_SECURITY_LOCKOUT
-- Object Type    : PACKAGE BODY
-- File           : PKG_SECURITY_LOCKOUT.pkb
-- Path           : database/modules/security/packages/body/PKG_SECURITY_LOCKOUT.pkb
-- Schema         : APEXONE
-- Description    : Applies the deterministic five-failure / fifteen-minute
--                  account lockout policy.
-- =============================================================================

CREATE OR REPLACE PACKAGE BODY PKG_SECURITY_LOCKOUT
IS
    PROCEDURE REGISTER_FAILURE
    (
        P_USER_ID IN APP_USERS.USER_ID%TYPE
    )
    IS
    BEGIN
        UPDATE APP_USERS
           SET FAILED_LOGIN_COUNT = NVL(FAILED_LOGIN_COUNT, 0) + 1,
               LOCKED_UNTIL = CASE
                   WHEN NVL(FAILED_LOGIN_COUNT, 0) + 1 >= 5
                   THEN SYSTIMESTAMP + INTERVAL '15' MINUTE
                   ELSE LOCKED_UNTIL
               END,
               UPDATED_AT = SYSTIMESTAMP,
               UPDATED_BY = USER
         WHERE USER_ID = P_USER_ID;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'User does not exist.');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            PKG_ERRORS.RAISE_ERROR(P_CODE => SQLCODE, P_MESSAGE => SQLERRM);
    END REGISTER_FAILURE;
END PKG_SECURITY_LOCKOUT;
/

-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Lockout
-- Object Name    : PKG_SECURITY_LOCKOUT
-- Object Type    : PACKAGE SPECIFICATION
-- File           : PKG_SECURITY_LOCKOUT.pks
-- Path           : database/modules/security/packages/spec/PKG_SECURITY_LOCKOUT.pks
-- Schema         : APEXONE
-- Description    : Central security lockout policy for failed authentication.
-- =============================================================================

CREATE OR REPLACE PACKAGE PKG_SECURITY_LOCKOUT
IS
    PROCEDURE REGISTER_FAILURE
    (
        P_USER_ID IN APP_USERS.USER_ID%TYPE
    );
END PKG_SECURITY_LOCKOUT;
/

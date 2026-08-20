-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Packages
-- Object Name    : PKG_SECURITY_POLICY
-- Object Type    : PACKAGE BODY
-- File           : PKG_SECURITY_POLICY.pkb
-- Path           : database/modules/security/packages/body/PKG_SECURITY_POLICY.pkb
-- Schema         : APEXONE
-- Version        : 2.0.0-alpha.2
-- Status         : Development
-- =============================================================================
-- Password hashing and verification are delegated to PKG_SECURITY_HASH.
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

CREATE OR REPLACE PACKAGE BODY PKG_SECURITY_POLICY
IS

------------------------------------------------------------------------
-- ENFORCE COMPLEXITY
------------------------------------------------------------------------
PROCEDURE ENFORCE_COMPLEXITY
(
    P_PASSWORD IN VARCHAR2
)
IS
BEGIN
    IF P_PASSWORD IS NULL THEN
        RAISE_APPLICATION_ERROR(
            -20100,
            'Password is required.'
        );
    END IF;

    IF LENGTH(P_PASSWORD) < 8 THEN
        RAISE_APPLICATION_ERROR(
            -20100,
            'Password must contain at least 8 characters.'
        );
    END IF;

    IF NOT REGEXP_LIKE(P_PASSWORD, '[A-Z]') THEN
        RAISE_APPLICATION_ERROR(
            -20101,
            'Password must contain at least one uppercase letter.'
        );
    END IF;

    IF NOT REGEXP_LIKE(P_PASSWORD, '[a-z]') THEN
        RAISE_APPLICATION_ERROR(
            -20102,
            'Password must contain at least one lowercase letter.'
        );
    END IF;

    IF NOT REGEXP_LIKE(P_PASSWORD, '[0-9]') THEN
        RAISE_APPLICATION_ERROR(
            -20103,
            'Password must contain at least one number.'
        );
    END IF;

    IF NOT REGEXP_LIKE(P_PASSWORD, '[^A-Za-z0-9]') THEN
        RAISE_APPLICATION_ERROR(
            -20104,
            'Password must contain at least one special character.'
        );
    END IF;
END ENFORCE_COMPLEXITY;

------------------------------------------------------------------------
-- CHECK EXPIRY
------------------------------------------------------------------------
PROCEDURE CHECK_EXPIRY
(
    P_USER_ID IN NUMBER
)
IS
    L_EXPIRY APP_USERS.PASSWORD_EXPIRES_AT%TYPE;
BEGIN
    SELECT PASSWORD_EXPIRES_AT
    INTO L_EXPIRY
    FROM APP_USERS
    WHERE USER_ID = P_USER_ID;

    IF L_EXPIRY IS NOT NULL
       AND L_EXPIRY < SYSTIMESTAMP
    THEN
        RAISE_APPLICATION_ERROR(
            -20110,
            'Password expired.'
        );
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20111,
            'User not found.'
        );
END CHECK_EXPIRY;

------------------------------------------------------------------------
-- CHANGE PASSWORD
------------------------------------------------------------------------
PROCEDURE CHANGE_PASSWORD
(
    P_USER_ID IN NUMBER,
    P_PASSWORD IN VARCHAR2
)
IS
    L_CURRENT_HASH APP_USERS.PASSWORD_VERIFIER%TYPE;
    L_CURRENT_SALT APP_USERS.PASSWORD_SALT%TYPE;
    L_NEW_SALT APP_USERS.PASSWORD_SALT%TYPE;
    L_NEW_HASH APP_USERS.PASSWORD_VERIFIER%TYPE;
    L_REUSE_FOUND NUMBER := 0;
BEGIN
    ENFORCE_COMPLEXITY(
        P_PASSWORD => P_PASSWORD
    );

    BEGIN
        SELECT PASSWORD_VERIFIER,
               PASSWORD_SALT
        INTO L_CURRENT_HASH,
             L_CURRENT_SALT
        FROM APP_USERS
        WHERE USER_ID = P_USER_ID
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20111,
                'User not found.'
            );
    END;

    IF L_CURRENT_HASH IS NOT NULL
       AND L_CURRENT_SALT IS NOT NULL
       AND PKG_SECURITY_HASH.VERIFY_PASSWORD(
               P_PASSWORD => P_PASSWORD,
               P_STORED_HASH => L_CURRENT_HASH,
               P_STORED_SALT => L_CURRENT_SALT
           )
    THEN
        RAISE_APPLICATION_ERROR(
            -20112,
            'Password was recently used.'
        );
    END IF;

    FOR R IN
    (
        SELECT PASSWORD_HASH,
               PASSWORD_SALT
        FROM
        (
            SELECT PASSWORD_HASH,
                   PASSWORD_SALT
            FROM APP_PASSWORD_HISTORY
            WHERE USER_ID = P_USER_ID
            ORDER BY CHANGED_AT DESC
        )
        WHERE ROWNUM <= 5
    )
    LOOP
        IF PKG_SECURITY_HASH.VERIFY_PASSWORD(
               P_PASSWORD => P_PASSWORD,
               P_STORED_HASH => R.PASSWORD_HASH,
               P_STORED_SALT => R.PASSWORD_SALT
           )
        THEN
            L_REUSE_FOUND := 1;
            EXIT;
        END IF;
    END LOOP;

    IF L_REUSE_FOUND = 1 THEN
        RAISE_APPLICATION_ERROR(
            -20112,
            'Password was recently used.'
        );
    END IF;

    L_NEW_SALT := PKG_SECURITY_HASH.GENERATE_SALT;

    L_NEW_HASH := PKG_SECURITY_HASH.HASH_PASSWORD(
        P_PASSWORD => P_PASSWORD,
        P_SALT => L_NEW_SALT
    );

    IF L_CURRENT_HASH IS NOT NULL
       AND L_CURRENT_SALT IS NOT NULL
    THEN
        INSERT INTO APP_PASSWORD_HISTORY
        (
            USER_ID,
            PASSWORD_HASH,
            PASSWORD_SALT,
            CHANGED_AT
        )
        VALUES
        (
            P_USER_ID,
            L_CURRENT_HASH,
            L_CURRENT_SALT,
            SYSTIMESTAMP
        );
    END IF;

    UPDATE APP_USERS
    SET PASSWORD_VERIFIER = L_NEW_HASH,
        PASSWORD_SALT = L_NEW_SALT,
        PASSWORD_CHANGED_AT = SYSTIMESTAMP,
        PASSWORD_EXPIRES_AT = SYSTIMESTAMP + INTERVAL '90' DAY,
        FORCE_PASSWORD_RESET = 'N',
        UPDATED_AT = SYSTIMESTAMP,
        UPDATED_BY = USER
    WHERE USER_ID = P_USER_ID;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20111,
            'User not found.'
        );
    END IF;

    DELETE FROM APP_PASSWORD_HISTORY
    WHERE USER_ID = P_USER_ID
      AND ROWID IN
      (
          SELECT RID
          FROM
          (
              SELECT ROWID AS RID,
                     ROW_NUMBER() OVER(
                         ORDER BY CHANGED_AT DESC,
                                  ROWID DESC
                     ) AS RN
              FROM APP_PASSWORD_HISTORY
              WHERE USER_ID = P_USER_ID
          )
          WHERE RN > 5
      );
END CHANGE_PASSWORD;

END PKG_SECURITY_POLICY;
/

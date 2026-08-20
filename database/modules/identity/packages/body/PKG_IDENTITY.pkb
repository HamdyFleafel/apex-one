-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Packages
-- Object Name    : PKG_IDENTITY
-- Object Type    : PACKAGE BODY
-- File           : PKG_IDENTITY.pkb
-- Path           : database/modules/identity/packages/body/PKG_IDENTITY.pkb
-- Schema         : APEXONE
-- Version        : 2.0.0-alpha.2
-- Status         : Development
-- =============================================================================
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
--
-- Description    : Identity service aligned with APP_USERS current structure.
--                  Initial passwords are also recorded in APP_PASSWORD_HISTORY
--                  to enforce password reuse prevention from account creation.
--
-- Change Log     :
--   2026-08-12  HF  Record initial password in APP_PASSWORD_HISTORY.
--
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

CREATE OR REPLACE PACKAGE BODY PKG_IDENTITY
IS

    ----------------------------------------------------------------------------
    -- USER MANAGEMENT
    ----------------------------------------------------------------------------

    FUNCTION CREATE_USER
    (
        P_USERNAME  IN VARCHAR2,
        P_EMAIL     IN VARCHAR2,
        P_PASSWORD  IN VARCHAR2
    )
    RETURN NUMBER
    IS
        L_USER_ID       APP_USERS.USER_ID%TYPE;
        L_SALT          VARCHAR2(128);
        L_VERIFIER      APP_USERS.PASSWORD_VERIFIER%TYPE;
        L_EXISTS        NUMBER;
    BEGIN

        ------------------------------------------------------------------------
        -- Validate Username
        ------------------------------------------------------------------------

        SELECT COUNT(*)
          INTO L_EXISTS
          FROM APP_USERS
         WHERE UPPER(USERNAME) = UPPER(P_USERNAME);

        IF L_EXISTS > 0 THEN

            PKG_ERRORS.RAISE_IDENTITY_ERROR
            (
                P_MESSAGE => 'Username already exists.'
            );

        END IF;


        ------------------------------------------------------------------------
        -- Validate Email
        ------------------------------------------------------------------------

        SELECT COUNT(*)
          INTO L_EXISTS
          FROM APP_USERS
         WHERE LOWER(EMAIL) = LOWER(P_EMAIL);

        IF L_EXISTS > 0 THEN

            PKG_ERRORS.RAISE_IDENTITY_ERROR
            (
                P_MESSAGE => 'Email already exists.'
            );

        END IF;


        ------------------------------------------------------------------------
        -- Generate Password Salt
        ------------------------------------------------------------------------

        L_SALT := PKG_SECURITY_HASH.GENERATE_SALT;


        ------------------------------------------------------------------------
        -- Generate Password Verifier
        ------------------------------------------------------------------------

        L_VERIFIER := PKG_SECURITY_HASH.HASH_PASSWORD
        (
            P_PASSWORD => P_PASSWORD,
            P_SALT     => L_SALT
        );


        ------------------------------------------------------------------------
        -- Create User
        ------------------------------------------------------------------------

        INSERT INTO APP_USERS
        (
            USER_ID,
            USERNAME,
            EMAIL,
            PASSWORD_VERIFIER,
            PASSWORD_SALT,
            ACCOUNT_STATUS_CODE,
            FAILED_LOGIN_COUNT,
            CREATED_AT,
            CREATED_BY
        )
        VALUES
        (
            SEQ_APP_USERS.NEXTVAL,
            UPPER(P_USERNAME),
            LOWER(P_EMAIL),
            L_VERIFIER,
            L_SALT,
            'ACTIVE',
            0,
            SYSTIMESTAMP,
            USER
        )
        RETURNING USER_ID
        INTO L_USER_ID;


        ------------------------------------------------------------------------
        -- Record Initial Password History
        --
        -- The first password must be stored in APP_PASSWORD_HISTORY.
        -- Otherwise the password-reuse policy cannot detect reuse of the
        -- original password after the first password change.
        ------------------------------------------------------------------------

        INSERT INTO APP_PASSWORD_HISTORY
        (
            USER_ID,
            PASSWORD_HASH,
            PASSWORD_SALT,
            CHANGED_AT
        )
        VALUES
        (
            L_USER_ID,
            L_VERIFIER,
            L_SALT,
            SYSTIMESTAMP
        );


        ------------------------------------------------------------------------
        -- Return Created User ID
        ------------------------------------------------------------------------

        RETURN L_USER_ID;


    EXCEPTION

        WHEN OTHERS THEN

            RAISE;

    END CREATE_USER;


    ----------------------------------------------------------------------------
    -- USER STATUS MANAGEMENT
    ----------------------------------------------------------------------------

    PROCEDURE UPDATE_USER_STATUS
    (
        P_USER_ID               IN APP_USERS.USER_ID%TYPE,
        P_ACCOUNT_STATUS_CODE   IN APP_USERS.ACCOUNT_STATUS_CODE%TYPE
    )
    IS
        L_EXISTS NUMBER;
    BEGIN

        ------------------------------------------------------------------------
        -- Validate User
        ------------------------------------------------------------------------

        SELECT COUNT(*)
          INTO L_EXISTS
          FROM APP_USERS
         WHERE USER_ID = P_USER_ID;

        IF L_EXISTS = 0 THEN

            PKG_ERRORS.RAISE_IDENTITY_ERROR
            (
                P_MESSAGE => 'User does not exist.'
            );

        END IF;


        ------------------------------------------------------------------------
        -- Update Status
        ------------------------------------------------------------------------

        UPDATE APP_USERS
           SET ACCOUNT_STATUS_CODE = UPPER(P_ACCOUNT_STATUS_CODE),
               UPDATED_AT          = SYSTIMESTAMP,
               UPDATED_BY          = USER
         WHERE USER_ID             = P_USER_ID;


    EXCEPTION

        WHEN OTHERS THEN

            PKG_ERRORS.RAISE_ERROR
            (
                P_CODE    => SQLCODE,
                P_MESSAGE => SQLERRM
            );

    END UPDATE_USER_STATUS;


    ----------------------------------------------------------------------------
    -- ACCOUNT LOCKING
    ----------------------------------------------------------------------------

    PROCEDURE LOCK_USER
    (
        P_USER_ID IN APP_USERS.USER_ID%TYPE
    )
    IS
        L_EXISTS NUMBER;
    BEGIN

        ------------------------------------------------------------------------
        -- Validate User
        ------------------------------------------------------------------------

        SELECT COUNT(*)
          INTO L_EXISTS
          FROM APP_USERS
         WHERE USER_ID = P_USER_ID;

        IF L_EXISTS = 0 THEN

            PKG_ERRORS.RAISE_IDENTITY_ERROR
            (
                P_MESSAGE => 'User does not exist.'
            );

        END IF;


        ------------------------------------------------------------------------
        -- Lock Account
        ------------------------------------------------------------------------

        UPDATE APP_USERS
           SET ACCOUNT_STATUS_CODE = 'LOCKED',
               LOCKED_UNTIL        = SYSTIMESTAMP,
               UPDATED_AT          = SYSTIMESTAMP,
               UPDATED_BY          = USER
         WHERE USER_ID             = P_USER_ID;


    EXCEPTION

        WHEN OTHERS THEN

            PKG_ERRORS.RAISE_ERROR
            (
                P_CODE    => SQLCODE,
                P_MESSAGE => SQLERRM
            );

    END LOCK_USER;


    ----------------------------------------------------------------------------
    -- ROLE MANAGEMENT
    ----------------------------------------------------------------------------

    PROCEDURE ASSIGN_ROLE
    (
        P_USER_ID   IN APP_USERS.USER_ID%TYPE,
        P_ROLE_CODE IN VARCHAR2
    )
    IS
        L_ROLE_ID   APP_ROLES.ROLE_ID%TYPE;
        L_EXISTS    NUMBER;
    BEGIN

        ------------------------------------------------------------------------
        -- Resolve Role
        ------------------------------------------------------------------------

        SELECT ROLE_ID
          INTO L_ROLE_ID
          FROM APP_ROLES
         WHERE UPPER(ROLE_CODE) = UPPER(P_ROLE_CODE);


        ------------------------------------------------------------------------
        -- Prevent Duplicate Assignment
        ------------------------------------------------------------------------

        SELECT COUNT(*)
          INTO L_EXISTS
          FROM APP_USER_ROLES
         WHERE USER_ID = P_USER_ID
           AND ROLE_ID = L_ROLE_ID;

        IF L_EXISTS = 0 THEN

            INSERT INTO APP_USER_ROLES
            (
                USER_ID,
                ROLE_ID
            )
            VALUES
            (
                P_USER_ID,
                L_ROLE_ID
            );

        END IF;


    EXCEPTION

        WHEN NO_DATA_FOUND THEN

            PKG_ERRORS.RAISE_IDENTITY_ERROR
            (
                P_MESSAGE => 'Role not found.'
            );

        WHEN OTHERS THEN

            PKG_ERRORS.RAISE_ERROR
            (
                P_CODE    => SQLCODE,
                P_MESSAGE => SQLERRM
            );

    END ASSIGN_ROLE;


    ----------------------------------------------------------------------------
    -- ROLE MANAGEMENT
    ----------------------------------------------------------------------------

    PROCEDURE REVOKE_ROLE
    (
        P_USER_ID   IN APP_USERS.USER_ID%TYPE,
        P_ROLE_CODE IN VARCHAR2
    )
    IS
        L_ROLE_ID   APP_ROLES.ROLE_ID%TYPE;
    BEGIN

        ------------------------------------------------------------------------
        -- Resolve Role
        ------------------------------------------------------------------------

        SELECT ROLE_ID
          INTO L_ROLE_ID
          FROM APP_ROLES
         WHERE UPPER(ROLE_CODE) = UPPER(P_ROLE_CODE);


        ------------------------------------------------------------------------
        -- Remove Assignment
        ------------------------------------------------------------------------

        DELETE
          FROM APP_USER_ROLES
         WHERE USER_ID = P_USER_ID
           AND ROLE_ID = L_ROLE_ID;


    EXCEPTION

        WHEN NO_DATA_FOUND THEN

            PKG_ERRORS.RAISE_IDENTITY_ERROR
            (
                P_MESSAGE => 'Role not found.'
            );

        WHEN OTHERS THEN

            PKG_ERRORS.RAISE_ERROR
            (
                P_CODE    => SQLCODE,
                P_MESSAGE => SQLERRM
            );

    END REVOKE_ROLE;


    ----------------------------------------------------------------------------
    -- AUTHORIZATION
    ----------------------------------------------------------------------------

    FUNCTION IS_USER_AUTHORIZED
    (
        P_USER_ID      IN APP_USERS.USER_ID%TYPE,
        P_PERMISSION   IN VARCHAR2
    )
    RETURN BOOLEAN
    IS
        L_COUNT NUMBER;
    BEGIN

        ------------------------------------------------------------------------
        -- Check Permission
        ------------------------------------------------------------------------

        SELECT COUNT(*)
          INTO L_COUNT
          FROM APP_USER_ROLES UR,
               APP_ROLE_PERMISSIONS RP,
               APP_PERMISSIONS PERM
         WHERE RP.ROLE_ID = UR.ROLE_ID
           AND PERM.PERMISSION_ID = RP.PERMISSION_ID
           AND UR.USER_ID = P_USER_ID
           AND UPPER(PERM.PERMISSION_CODE) = UPPER(P_PERMISSION);


        RETURN L_COUNT > 0;


    EXCEPTION

        WHEN OTHERS THEN

            PKG_ERRORS.RAISE_ERROR
            (
                P_CODE    => SQLCODE,
                P_MESSAGE => SQLERRM
            );

            RETURN FALSE;

    END IS_USER_AUTHORIZED;

END PKG_IDENTITY;
/
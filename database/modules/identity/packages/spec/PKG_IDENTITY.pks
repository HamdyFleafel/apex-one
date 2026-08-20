-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Packages
-- Object Name    : PKG_IDENTITY
-- Object Type    : PACKAGE SPECIFICATION
-- File           : PKG_IDENTITY.pks
-- Path           : database/modules/identity/packages/spec/PKG_IDENTITY.pks
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Identity service layer API for user, role and authorization
--                  management.
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-05
-- Last Modified  : 2026-08-05
-- -----------------------------------------------------------------------------
-- Change Log     :
--   2026-08-05  HF  Initial creation.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

CREATE OR REPLACE PACKAGE PKG_IDENTITY
IS

    ----------------------------------------------------------------------------
    -- USER MANAGEMENT
    ----------------------------------------------------------------------------

    FUNCTION create_user
    (
        p_username  IN VARCHAR2,
        p_email     IN VARCHAR2,
        p_password  IN VARCHAR2
    )
    RETURN NUMBER;


    PROCEDURE UPDATE_USER_STATUS
    (
         P_USER_ID              IN APP_USERS.USER_ID%TYPE,
        P_ACCOUNT_STATUS_CODE  IN APP_USERS.ACCOUNT_STATUS_CODE%TYPE
    );

    PROCEDURE LOCK_USER
    (
    P_USER_ID IN APP_USERS.USER_ID%TYPE
    );

    ----------------------------------------------------------------------------
    -- ROLE MANAGEMENT
    ----------------------------------------------------------------------------

    PROCEDURE ASSIGN_ROLE
         (
        P_USER_ID   IN APP_USERS.USER_ID%TYPE,
        P_ROLE_CODE IN VARCHAR2
         );

          PROCEDURE REVOKE_ROLE
(
    P_USER_ID   IN APP_USERS.USER_ID%TYPE,
    P_ROLE_CODE IN VARCHAR2
);
    ----------------------------------------------------------------------------
    -- AUTHORIZATION
    ----------------------------------------------------------------------------

       FUNCTION IS_USER_AUTHORIZED
(
    P_USER_ID    IN APP_USERS.USER_ID%TYPE,
    P_PERMISSION IN VARCHAR2
)
RETURN BOOLEAN;

END PKG_IDENTITY;
/
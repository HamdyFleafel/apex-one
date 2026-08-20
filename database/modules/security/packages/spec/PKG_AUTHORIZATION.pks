-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Security
-- Component      : Authorization
-- Object Name    : PKG_AUTHORIZATION
-- Object Type    : PACKAGE SPECIFICATION
-- File           : PKG_AUTHORIZATION.pks
-- Path           : database/modules/security/packages/spec/PKG_AUTHORIZATION.pks
-- Schema         : APEXONE
-- Version        : 1.0.0-alpha.1
-- Status         : Development
-- =============================================================================
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : +20 1010506080
--
-- Description    : Authorization engine for the APEXONE RBAC model.
--                  Authorization is resolved through:
--
--                  APP_USER_ROLES
--                       -> APP_ROLE_PERMISSIONS
--                       -> APP_PERMISSIONS
--
--                  Authentication is handled separately by
--                  PKG_AUTHENTICATION.
-- =============================================================================

CREATE OR REPLACE PACKAGE PKG_AUTHORIZATION
IS

    FUNCTION HAS_PERMISSION
    (
        P_USER_ID         IN NUMBER,
        P_PERMISSION_CODE IN VARCHAR2
    )
    RETURN BOOLEAN;

    FUNCTION HAS_ANY_PERMISSION
    (
        P_USER_ID          IN NUMBER,
        P_PERMISSION_CODES IN VARCHAR2
    )
    RETURN BOOLEAN;

    FUNCTION HAS_ALL_PERMISSIONS
    (
        P_USER_ID          IN NUMBER,
        P_PERMISSION_CODES IN VARCHAR2
    )
    RETURN BOOLEAN;

    PROCEDURE REQUIRE_PERMISSION
    (
        P_USER_ID         IN NUMBER,
        P_PERMISSION_CODE IN VARCHAR2
    );

    PROCEDURE REQUIRE_ANY_PERMISSION
    (
        P_USER_ID          IN NUMBER,
        P_PERMISSION_CODES IN VARCHAR2
    );

    PROCEDURE REQUIRE_ALL_PERMISSIONS
    (
        P_USER_ID          IN NUMBER,
        P_PERMISSION_CODES IN VARCHAR2
    );

END PKG_AUTHORIZATION;
/
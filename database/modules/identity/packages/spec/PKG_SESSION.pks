-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Session Management
-- Object Name    : PKG_SESSION
-- Object Type    : PACKAGE
-- File           : PKG_SESSION.pks
-- Path           : D:\Workspace\apex-one\database\modules\identity\packages\spec\PKG_SESSION.pks
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development

-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080

-- Description    : Provides application session management operations for
--                  session creation, validation, individual revocation,
--                  and user-wide session revocation.

-- Created On     : 2026-08-10
-- Last Modified  : 2026-08-10

-- Change Log     :
--   2026-08-10  HF  Added application session management package specification.
--   2026-08-10  HF  Standardized session management API.

-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

CREATE OR REPLACE PACKAGE PKG_SESSION
IS
    FUNCTION create_session
    (
        p_user_id    IN APP_SESSIONS.USER_ID%TYPE,
        p_ip_address IN APP_SESSIONS.IP_ADDRESS%TYPE DEFAULT NULL,
        p_user_agent IN APP_SESSIONS.USER_AGENT%TYPE DEFAULT NULL
    )
    RETURN VARCHAR2;

    FUNCTION validate_session
    (
        p_session_token IN APP_SESSIONS.SESSION_TOKEN%TYPE
    )
    RETURN NUMBER;

    PROCEDURE revoke_session
    (
        p_session_token IN APP_SESSIONS.SESSION_TOKEN%TYPE
    );

    PROCEDURE revoke_all_user_sessions
    (
        p_user_id IN APP_SESSIONS.USER_ID%TYPE
    );
END PKG_SESSION;
/
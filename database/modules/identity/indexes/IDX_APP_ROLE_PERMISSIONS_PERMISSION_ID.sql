-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Indexes
-- Object Name    : IDX_APP_ROLE_PERMISSIONS_PERMISSION_ID
-- Object Type    : INDEX
-- File           : IDX_APP_ROLE_PERMISSIONS_PERMISSION_ID.sql
-- Path           : database/modules/identity/indexes/IDX_APP_ROLE_PERMISSIONS_PERMISSION_ID.sql
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Indexes APP_ROLE_PERMISSIONS.PERMISSION_ID to support
--                  permission-based joins and foreign-key access paths.
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-07
-- Last Modified  : 2026-08-07
-- -----------------------------------------------------------------------------
-- Change Log     :
--   2026-08-07  HF  Initial creation.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================
PROMPT Checking IDX_APP_ROLE_PERMISSIONS_PERMISSION_ID

DECLARE
    l_exists PLS_INTEGER;
BEGIN
    SELECT COUNT(*)
      INTO l_exists
      FROM USER_INDEXES
     WHERE INDEX_NAME = UPPER('IDX_APP_ROLE_PERMISSIONS_PERMISSION_ID');

    IF l_exists = 0 THEN
        EXECUTE IMMEDIATE 'CREATE INDEX IDX_APP_ROLE_PERMISSIONS_PERMISSION_ID ON APP_ROLE_PERMISSIONS (PERMISSION_ID) TABLESPACE APEXONE_INDEX';
        DBMS_OUTPUT.PUT_LINE('IDX_APP_ROLE_PERMISSIONS_PERMISSION_ID : CREATED');
    ELSE
        DBMS_OUTPUT.PUT_LINE('IDX_APP_ROLE_PERMISSIONS_PERMISSION_ID : EXISTS - SKIPPED');
    END IF;
END;
/

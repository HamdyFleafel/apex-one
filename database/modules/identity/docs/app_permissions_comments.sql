-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Documentation
-- Object Name    : APP_PERMISSIONS
-- Object Type    : COMMENTS SCRIPT
-- File           : app_permissions_comments.sql
-- Path           : database/modules/identity/docs/app_permissions_comments.sql
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Defines Oracle comments for APP_PERMISSIONS.
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-05
-- Last Modified  : 2026-08-05
-- -----------------------------------------------------------------------------
-- Change Log     :
--   2026-08-05  HF  Initial creation.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

PROMPT ============================================================================
PROMPT Applying APP_PERMISSIONS Comments
PROMPT ============================================================================

COMMENT ON TABLE APP_PERMISSIONS
IS 'Stores platform permissions used by the APEXONE RBAC model.';

COMMENT ON COLUMN APP_PERMISSIONS.PERMISSION_ID
IS 'Identity primary key for the permission.';

COMMENT ON COLUMN APP_PERMISSIONS.PERMISSION_CODE
IS 'Unique uppercase permission code.';

COMMENT ON COLUMN APP_PERMISSIONS.PERMISSION_NAME
IS 'Human-readable permission name.';

COMMENT ON COLUMN APP_PERMISSIONS.DESCRIPTION
IS 'Detailed permission description.';

COMMENT ON COLUMN APP_PERMISSIONS.STATUS
IS 'Permission status: ACTIVE or INACTIVE.';

COMMENT ON COLUMN APP_PERMISSIONS.IS_DELETED
IS 'Logical deletion flag: Y or N.';

COMMENT ON COLUMN APP_PERMISSIONS.CREATED_AT
IS 'Permission creation timestamp.';

COMMENT ON COLUMN APP_PERMISSIONS.CREATED_BY
IS 'Database user that created the permission.';

COMMENT ON COLUMN APP_PERMISSIONS.UPDATED_AT
IS 'Last update timestamp.';

COMMENT ON COLUMN APP_PERMISSIONS.UPDATED_BY
IS 'Database user that performed the last update.';

PROMPT Completed.
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Core
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Created On     : 2026-08-08
-- Last Modified  : 2026-08-08
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

-- Component      : APP_FILE_METADATA Status Index
-- Object Name    : APP_FILE_METADATA_STATUS_IDX
-- Object Type    : INDEX
-- Description    : Supports lifecycle/status filtering.
-- Change Log :
-- 2026-08-08 HF Initial creation.
-- =============================================================================

DECLARE
    l_count NUMBER;
BEGIN

    SELECT COUNT(*)
    INTO l_count
    FROM USER_INDEXES
    WHERE INDEX_NAME = 'APP_FILE_METADATA_STATUS_IDX';


    IF l_count = 0 THEN

        EXECUTE IMMEDIATE '
            CREATE INDEX APP_FILE_METADATA_STATUS_IDX
            ON APP_FILE_METADATA (FILE_STATUS)
            TABLESPACE APEXONE_INDEX
        ';


        DBMS_OUTPUT.PUT_LINE(
            'APP_FILE_METADATA_STATUS_IDX created successfully.'
        );


    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'APP_FILE_METADATA_STATUS_IDX exists. Skipping.'
        );


    END IF;

END;
/

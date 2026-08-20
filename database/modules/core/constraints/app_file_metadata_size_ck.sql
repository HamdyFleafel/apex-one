-- =============================================================================
-- Project : APEXONE Enterprise Platform
-- Module : Core
-- Schema : APEXONE
-- Version : 1.3.0-alpha.1
-- Status : Development
-- -----------------------------------------------------------------------------
-- Author : Hamdy Fleafel
-- Title : Enterprise Database Architect
-- Email : hamdy.fleafel@belcofarms.com
-- WhatsApp : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Created On : 2026-08-08
-- Last Modified : 2026-08-08
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

-- Component : APP_FILE_METADATA File Size Check
-- Description : Prevents negative file sizes.
-- Change Log :
-- 2026-08-08 HF Initial creation.
-- =============================================================================

DECLARE
    l_count NUMBER;
BEGIN

    SELECT COUNT(*)
    INTO l_count
    FROM USER_CONSTRAINTS
    WHERE CONSTRAINT_NAME='APP_FILE_METADATA_SIZE_CK';


    IF l_count=0 THEN

        EXECUTE IMMEDIATE
        '
        ALTER TABLE APP_FILE_METADATA
        ADD CONSTRAINT APP_FILE_METADATA_SIZE_CK
        CHECK (FILE_SIZE_BYTES >= 0)
        ';

        DBMS_OUTPUT.PUT_LINE(
            'APP_FILE_METADATA_SIZE_CK created.'
        );

    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'APP_FILE_METADATA_SIZE_CK exists. Skipping.'
        );

    END IF;

END;
/
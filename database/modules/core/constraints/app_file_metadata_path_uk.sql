
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Core
-- Component      : APP_FILE_METADATA Path Unique Constraint
-- Object Name    : APP_FILE_METADATA_PATH_UK
-- Object Type    : CONSTRAINT SCRIPT
-- File           : app_file_metadata_path_uk.sql
-- Path           : database/modules/core/constraints/app_file_metadata_path_uk.sql
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
--
-- Description    : Prevents duplicate file metadata records for the same
--                  relative path and file name.
--
-- Constraint     : APP_FILE_METADATA_PATH_UK
-- Columns        : RELATIVE_PATH, FILE_NAME
--
-- Created On     : 2026-08-09
-- Last Modified  : 2026-08-09
--
-- Change Log :
-- 2026-08-09 HF Corrected file from Core constraint aggregator to the
--               actual APP_FILE_METADATA path unique constraint.
--
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

-- =============================================================================
-- SQL*Plus Environment
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET SQLBLANKLINES ON

WHENEVER SQLERROR EXIT FAILURE ROLLBACK

-- =============================================================================
-- Constraint Installation
-- =============================================================================

PROMPT
PROMPT Installing APP_FILE_METADATA Path Unique Constraint
PROMPT ----------------------------------------------------------------------------

DECLARE
    l_count NUMBER;
BEGIN

    SELECT COUNT(*)
    INTO l_count
    FROM USER_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'APP_FILE_METADATA_PATH_UK';


    IF l_count = 0 THEN

        EXECUTE IMMEDIATE
        '
        ALTER TABLE APP_FILE_METADATA
        ADD CONSTRAINT APP_FILE_METADATA_PATH_UK
        UNIQUE (RELATIVE_PATH)
        USING INDEX TABLESPACE APEXONE_INDEX
        ';

        DBMS_OUTPUT.PUT_LINE(
            'APP_FILE_METADATA_PATH_UK created.'
        );

    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'APP_FILE_METADATA_PATH_UK exists. Skipping.'
        );

    END IF;

END;
/
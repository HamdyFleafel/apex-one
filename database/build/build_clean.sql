
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Database Build System
-- Component      : Orchestration
-- Object Name    : BUILD_CLEAN
-- Object Type    : SCRIPT
-- File           : build_clean.sql
-- Path           : database/build/build_clean.sql
-- Schema         : APEXONE
-- Version        : 2.3.0-alpha.2
-- Status         : Development
--
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
--
-- Description    : Performs full clean rebuild preparation by dropping
--                  modules in reverse dependency order and purging objects.
--                  Core cleanup includes APP_FILE_METADATA.
--
-- Created On     : 2026-08-05
-- Last Modified  : 2026-08-08
--
-- Change Log     :
--   2026-08-05  HF  Initial creation.
--   2026-08-08  HF  Added Core cleanup for APP_FILE_METADATA and dependent
--                   indexes/constraints to support clean rebuilds.
--
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================

PROMPT ============================================================================
PROMPT Starting APEXONE Clean Rebuild
PROMPT ============================================================================

WHENEVER SQLERROR CONTINUE
WHENEVER OSERROR EXIT FAILURE ROLLBACK

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET SQLBLANKLINES ON

-- =============================================================================
-- Step 1: Dropping Security Module Objects
-- =============================================================================

PROMPT ============================================================================
PROMPT Step 1: Dropping Security Module Objects
PROMPT ============================================================================

BEGIN
    FOR rec IN (
        SELECT object_name, object_type
        FROM user_objects
        WHERE object_name LIKE 'APP_SESSION%'
           OR object_name LIKE 'APP_LOGIN%'
           OR object_name LIKE 'APP_PASSWORD%'
           OR object_name LIKE 'PKG_AUTHENTICATION%'
           OR object_name LIKE 'PKG_SESSION%'
           OR object_name LIKE 'PKG_SECURITY%'
    )
    LOOP
        BEGIN
            EXECUTE IMMEDIATE
                'DROP ' || rec.object_type || ' "' || rec.object_name || '"';

            DBMS_OUTPUT.PUT_LINE(
                'Dropped ' || rec.object_type || ' ' || rec.object_name
            );
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
    END LOOP;
END;
/

-- =============================================================================
-- Step 2: Dropping Core Module Objects
-- =============================================================================

PROMPT ============================================================================
PROMPT Step 2: Dropping Core Module Objects
PROMPT ============================================================================

BEGIN
    -- APP_FILE_METADATA table.
    -- CASCADE CONSTRAINTS removes its PK/UK/check constraints and
    -- the associated constraint-backed indexes.
    BEGIN
        EXECUTE IMMEDIATE
            'DROP TABLE APP_FILE_METADATA CASCADE CONSTRAINTS';

        DBMS_OUTPUT.PUT_LINE(
            'Dropped TABLE APP_FILE_METADATA'
        );
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;

    -- Remove any remaining standalone indexes that belong to the
    -- APP_FILE_METADATA object family.
    FOR rec IN (
        SELECT object_name
        FROM user_objects
        WHERE object_type = 'INDEX'
          AND object_name LIKE 'APP_FILE_METADATA%'
    )
    LOOP
        BEGIN
            EXECUTE IMMEDIATE
                'DROP INDEX "' || rec.object_name || '"';

            DBMS_OUTPUT.PUT_LINE(
                'Dropped INDEX ' || rec.object_name
            );
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
    END LOOP;
END;
/

-- =============================================================================
-- Step 3: Dropping Identity Module Objects
-- =============================================================================

PROMPT ============================================================================
PROMPT Step 3: Dropping Identity Module Objects
PROMPT ============================================================================

BEGIN
    FOR rec IN (
        SELECT object_name, object_type
        FROM user_objects
        WHERE object_name LIKE 'APP_USER%'
           OR object_name LIKE 'APP_ROLE%'
           OR object_name LIKE 'APP_PERMISSION%'
           OR object_name LIKE 'PKG_IDENTITY%'
    )
    LOOP
        BEGIN
            EXECUTE IMMEDIATE
                'DROP ' || rec.object_type || ' "' || rec.object_name || '"';

            DBMS_OUTPUT.PUT_LINE(
                'Dropped ' || rec.object_type || ' ' || rec.object_name
            );
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
    END LOOP;
END;
/

-- =============================================================================
-- Step 4: Dropping Framework Packages
-- =============================================================================

PROMPT ============================================================================
PROMPT Step 4: Dropping Framework Packages
PROMPT ============================================================================

BEGIN
    FOR rec IN (
        SELECT object_name, object_type
        FROM user_objects
        WHERE object_name LIKE 'PKG_ERRORS%'
    )
    LOOP
        BEGIN
            EXECUTE IMMEDIATE
                'DROP ' || rec.object_type || ' "' || rec.object_name || '"';

            DBMS_OUTPUT.PUT_LINE(
                'Dropped ' || rec.object_type || ' ' || rec.object_name
            );
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
    END LOOP;
END;
/

-- =============================================================================
-- Step 5: Purging Recyclebin
-- =============================================================================

PROMPT ============================================================================
PROMPT Step 5: Purging Recyclebin
PROMPT ============================================================================

BEGIN
    EXECUTE IMMEDIATE 'PURGE RECYCLEBIN';

    DBMS_OUTPUT.PUT_LINE('Recyclebin purged.');
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

-- =============================================================================
-- Completion
-- =============================================================================

PROMPT ============================================================================
PROMPT APEXONE Clean Rebuild Completed
PROMPT ============================================================================

COMMIT;

PROMPT ============================================================================
PROMPT Clean state ready for full rebuild.
PROMPT ============================================================================


/*====================================================================
  APEXONE Enterprise Platform

  File Name    : verify_object_storage.sql
  Module       : Database Verification

  Purpose:
  Verifies APEXONE database object storage allocation.

  Database     : Oracle AI Database 26ai

  Version      : 1.0.0-alpha.5

  Change History:
  --------------------------------------------------------------------
  Version          Date          Description
  --------------------------------------------------------------------
  1.0.0-alpha.5    2026-08-04    Added object storage verification
====================================================================*/

PROMPT ==========================================
PROMPT APEXONE OBJECT STORAGE VERIFICATION
PROMPT ==========================================

SET LINESIZE 200
SET PAGESIZE 200
SET FEEDBACK ON
SET VERIFY OFF

PROMPT
PROMPT Checking Tables Storage...
PROMPT ==========================================

SELECT
    table_name,
    tablespace_name
FROM
    user_tables
ORDER BY
    table_name;


PROMPT
PROMPT Checking Index Storage...
PROMPT ==========================================

SELECT
    index_name,
    table_name,
    tablespace_name
FROM
    user_indexes
ORDER BY
    table_name,
    index_name;


PROMPT
PROMPT Object Storage Verification Completed
PROMPT ==========================================

EXIT
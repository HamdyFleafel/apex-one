/*====================================================================
  APEXONE Enterprise Platform

  File Name    : verify_tablespaces.sql
  Module       : Database Verification

  Purpose:
  Verifies APEXONE enterprise tablespaces.

  Database     : Oracle AI Database 26ai

  Version      : 1.0.0-alpha.5

  Change History:
  --------------------------------------------------------------------
  Version          Date          Description
  --------------------------------------------------------------------
  1.0.0-alpha.5    2026-08-04    Added tablespace verification
====================================================================*/


PROMPT ==========================================
PROMPT APEXONE TABLESPACE VERIFICATION
PROMPT ==========================================


SET LINESIZE 200
SET PAGESIZE 100
SET FEEDBACK ON


PROMPT
PROMPT Checking Tablespaces...
PROMPT ==========================================


SELECT
    tablespace_name,
    status,
    contents
FROM
    dba_tablespaces
WHERE
    tablespace_name LIKE 'APEXONE%'
ORDER BY
    tablespace_name;


PROMPT
PROMPT Checking Datafiles...
PROMPT ==========================================


SELECT
    tablespace_name,
    file_name,
    bytes / 1024 / 1024 AS size_mb,
    autoextensible
FROM
    dba_data_files
WHERE
    tablespace_name LIKE 'APEXONE%'
ORDER BY
    tablespace_name;


PROMPT
PROMPT APEXONE Tablespace Verification Completed
PROMPT ==========================================


EXIT
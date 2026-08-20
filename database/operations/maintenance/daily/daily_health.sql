--==============================================================================
-- APEXONE ENTERPRISE PLATFORM
--==============================================================================
--
-- File.........: daily_health.sql
-- Module.......: Enterprise Maintenance Framework
-- Component....: Daily Database Health Check
-- Purpose......: Oracle Database Daily Health Report
-- Version......: 1.0.0
-- Status.......: Production
--
--==============================================================================

SET SERVEROUTPUT ON
SET LINESIZE 200
SET PAGESIZE 100

PROMPT ====================================================
PROMPT APEXONE DAILY DATABASE HEALTH CHECK
PROMPT ====================================================


PROMPT
PROMPT === DATABASE INFORMATION ===

SELECT
    NAME AS DATABASE_NAME,
    OPEN_MODE,
    DATABASE_ROLE
FROM
    V$DATABASE;


PROMPT
PROMPT === INSTANCE INFORMATION ===

SELECT
    INSTANCE_NAME,
    STATUS,
    VERSION
FROM
    V$INSTANCE;


PROMPT
PROMPT === CURRENT CONTAINER ===

SHOW CON_NAME


PROMPT
PROMPT === APEXONE USER STATUS ===

SELECT
    USERNAME,
    ACCOUNT_STATUS,
    DEFAULT_TABLESPACE
FROM
    DBA_USERS
WHERE
    USERNAME = 'APEXONE';


PROMPT
PROMPT === INVALID OBJECTS ===

SELECT
    OWNER,
    OBJECT_TYPE,
    COUNT(*) AS INVALID_COUNT
FROM
    DBA_OBJECTS
WHERE
    STATUS = 'INVALID'
GROUP BY
    OWNER,
    OBJECT_TYPE
ORDER BY
    OWNER;


PROMPT
PROMPT === TABLESPACE USAGE ===


SELECT
    DF.TABLESPACE_NAME,
    ROUND(DF.TOTAL_MB,2) TOTAL_MB,
    ROUND(FS.FREE_MB,2) FREE_MB,
    ROUND((DF.TOTAL_MB-FS.FREE_MB),2) USED_MB,
    ROUND(((DF.TOTAL_MB-FS.FREE_MB)/DF.TOTAL_MB)*100,2) USED_PERCENT
FROM
(
    SELECT
        TABLESPACE_NAME,
        SUM(BYTES)/1024/1024 TOTAL_MB
    FROM
        DBA_DATA_FILES
    GROUP BY
        TABLESPACE_NAME
) DF
JOIN
(
    SELECT
        TABLESPACE_NAME,
        SUM(BYTES)/1024/1024 FREE_MB
    FROM
        DBA_FREE_SPACE
    GROUP BY
        TABLESPACE_NAME
) FS
ON
DF.TABLESPACE_NAME = FS.TABLESPACE_NAME
ORDER BY
USED_PERCENT DESC;


PROMPT
PROMPT ====================================================
PROMPT DAILY HEALTH CHECK COMPLETED
PROMPT ====================================================

EXIT;
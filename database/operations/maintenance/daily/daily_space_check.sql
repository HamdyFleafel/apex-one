SET PAGESIZE 100
SET LINESIZE 200
SET FEEDBACK ON
SET VERIFY OFF

PROMPT ====================================================
PROMPT APEXONE DAILY TABLESPACE BASELINE CHECK
PROMPT ====================================================


PROMPT
PROMPT === TABLESPACE USAGE ===


SELECT
    d.tablespace_name,
    ROUND(SUM(d.bytes)/1024/1024) AS size_mb,
    ROUND(NVL(f.free_mb,0)) AS free_mb,
    ROUND(
        (SUM(d.bytes)/1024/1024) - NVL(f.free_mb,0)
    ) AS used_mb
FROM
    dba_data_files d
LEFT JOIN
(
    SELECT
        tablespace_name,
        SUM(bytes)/1024/1024 free_mb
    FROM
        dba_free_space
    GROUP BY
        tablespace_name
) f
ON d.tablespace_name=f.tablespace_name
GROUP BY
    d.tablespace_name,
    f.free_mb
ORDER BY
    size_mb DESC
;


PROMPT
PROMPT ====================================================
PROMPT AUTOEXTEND STATUS
PROMPT ====================================================


SELECT
    tablespace_name,
    autoextensible,
    ROUND(bytes/1024/1024) current_mb,
    ROUND(maxbytes/1024/1024) max_mb
FROM
    dba_data_files
ORDER BY
    tablespace_name
;


PROMPT
PROMPT ====================================================
PROMPT APEXONE DATAFILE CHECK
PROMPT ====================================================


SELECT
    tablespace_name,
    file_name,
    autoextensible,
    ROUND(bytes/1024/1024) current_mb,
    ROUND(maxbytes/1024/1024) max_mb
FROM
    dba_data_files
WHERE
    tablespace_name='APEXONE_DATA'
;


PROMPT
PROMPT ====================================================
PROMPT BASELINE CHECK COMPLETED
PROMPT ====================================================


EXIT;
/*====================================================================
APEXONE Enterprise Platform

File Name : tablespace_baseline.sql
Module    : Database Monitoring

Purpose:
Capture tablespace baseline information.

Version:
1.0.0
====================================================================*/

set linesize 200
set pagesize 100

prompt ==========================================
prompt APEXONE TABLESPACE BASELINE
prompt ==========================================


select
    tablespace_name,
    round(sum(bytes)/1024/1024,2) size_mb
from
    dba_data_files
group by
    tablespace_name
order by
    tablespace_name;


prompt ==========================================
prompt DATAFILES
prompt ==========================================


select
    tablespace_name,
    file_name,
    round(bytes/1024/1024,2) size_mb,
    autoextensible,
    round(maxbytes/1024/1024,2) max_mb
from
    dba_data_files
order by
    tablespace_name;


prompt ==========================================
prompt FREE SPACE
prompt ==========================================


select
    tablespace_name,
    round(sum(bytes)/1024/1024,2) free_mb
from
    dba_free_space
group by
    tablespace_name
order by
    tablespace_name;
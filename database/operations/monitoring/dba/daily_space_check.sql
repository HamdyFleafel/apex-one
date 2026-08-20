/*====================================================================
APEXONE Enterprise Platform

File Name : daily_space_check.sql
Module    : Database Monitoring

Purpose:
Daily tablespace monitoring.

Version:
1.0.0
====================================================================*/

set linesize 200
set pagesize 100
set feedback on

prompt ==========================================
prompt APEXONE DAILY SPACE CHECK
prompt ==========================================

select
    df.tablespace_name,
    round(df.total_mb,2) total_mb,
    round(fs.free_mb,2) free_mb,
    round(df.total_mb-fs.free_mb,2) used_mb,
    round((fs.free_mb/df.total_mb)*100,2) free_percent,
    case
        when (fs.free_mb/df.total_mb)*100 < 5
            then 'CRITICAL'
        when (fs.free_mb/df.total_mb)*100 < 15
            then 'WARNING'
        else 'OK'
    end status
from
(
    select
        tablespace_name,
        sum(bytes)/1024/1024 total_mb
    from dba_data_files
    group by tablespace_name
) df,
(
    select
        tablespace_name,
        sum(bytes)/1024/1024 free_mb
    from dba_free_space
    group by tablespace_name
) fs
where df.tablespace_name=fs.tablespace_name
order by free_percent;
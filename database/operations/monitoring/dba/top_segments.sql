/*====================================================================
APEXONE Enterprise Platform

File Name : top_segments.sql
Module    : Database Monitoring

Purpose:
Find largest database segments.

Version:
1.0.0
====================================================================*/

set linesize 200

prompt ==========================================
prompt TOP DATABASE SEGMENTS
prompt ==========================================

select
    owner,
    segment_name,
    segment_type,
    round(bytes/1024/1024,2) size_mb
from
    dba_segments
order by bytes desc
fetch first 30 rows only;
/*====================================================================
APEXONE Enterprise Platform

File Name : weekly_database_health.sql
Module    : Database Monitoring

Purpose:
Weekly database health report.

Version:
1.0.0
====================================================================*/

set linesize 200
set pagesize 100

prompt ==========================================
prompt DATABASE HEALTH CHECK
prompt ==========================================

prompt DATABASE VERSION

select banner
from v$version;

prompt INSTANCE STATUS

select
    instance_name,
    status,
    database_status
from v$instance;

prompt PDB STATUS

select
    name,
    open_mode
from v$pdbs;

prompt INVALID OBJECTS

select
    owner,
    object_type,
    count(*) invalid_count
from dba_objects
where status='INVALID'
group by owner,object_type;

prompt NON ORACLE USERS

select
    username,
    account_status,
    default_tablespace
from dba_users
where oracle_maintained='N';
/*====================================================================
  APEXONE Enterprise Platform

  File Name : environment_check.sql

  Purpose:
  Validate database environment before deployment.

  Version : 1.0.0

====================================================================*/

set serveroutput on


prompt =====================================
prompt APEXONE Environment Verification
prompt =====================================


select
    sys_context('USERENV','DB_NAME') as database_name,
    sys_context('USERENV','CURRENT_SCHEMA') as schema_name
from dual;


select
    tablespace_name,
    status
from user_tablespaces;


select
    username,
    account_status,
    default_tablespace
from user_users;


prompt Environment verification completed
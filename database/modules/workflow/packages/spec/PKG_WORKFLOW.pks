/*====================================================================
  APEXONE Enterprise Platform

  Object Type : PACKAGE SPEC

  Object Name : PKG_WORKFLOW

  Module      : Workflow Framework

  Version     : 1.0.0

====================================================================*/

create or replace package pkg_workflow
as


    procedure create_task
    (
        p_workflow_id number,
        p_task_code varchar2,
        p_task_name varchar2,
        p_user varchar2
    );


    procedure complete_task
    (
        p_task_id number
    );


end pkg_workflow;
/
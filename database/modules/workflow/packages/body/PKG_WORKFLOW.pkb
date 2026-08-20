/*====================================================================
  APEXONE Enterprise Platform

  Object Type : PACKAGE BODY

  Object Name : PKG_WORKFLOW

  Module      : Workflow Framework

  Version     : 1.0.0

====================================================================*/

create or replace package body pkg_workflow
as


procedure create_task
(
    p_workflow_id number,
    p_task_code varchar2,
    p_task_name varchar2,
    p_user varchar2
)

is

begin


    insert into app_workflow_tasks
    (
        workflow_id,
        task_code,
        task_name,
        assigned_user
    )

    values
    (
        p_workflow_id,
        p_task_code,
        p_task_name,
        p_user
    );


end create_task;



procedure complete_task
(
    p_task_id number
)

is

begin


    update app_workflow_tasks

    set task_status = 'COMPLETED',

        completed_date = systimestamp

    where task_id = p_task_id;


end complete_task;


end pkg_workflow;
/
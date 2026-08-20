/*====================================================================
  APEXONE Enterprise Platform

  File Name    : install_workflow.sql
  Module       : Workflow Framework

  Purpose:
  Installation script for APEXONE Workflow Module.

  Version      : 1.0.0-alpha.4
====================================================================*/

PROMPT ==========================================
PROMPT Installing WORKFLOW Module
PROMPT ==========================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET SQLBLANKLINES ON

WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT
PROMPT Creating Workflow Tables...
PROMPT ==========================================

@modules\workflow\tables\app_workflow_definitions.sql
@modules\workflow\tables\app_workflow_tasks.sql

PROMPT
PROMPT Applying Workflow Constraints...
PROMPT ==========================================

@modules\workflow\constraints\app_workflow_definitions_pk.sql
@modules\workflow\constraints\app_workflow_def_code_uk.sql
@modules\workflow\constraints\app_workflow_tasks_pk.sql
@modules\workflow\constraints\app_workflow_tasks_workflow_fk.sql
@modules\workflow\constraints\app_workflow_tasks_code_uk.sql

PROMPT
PROMPT Installing Workflow Packages...
PROMPT ==========================================

@modules\workflow\packages\spec\PKG_WORKFLOW.pks
@modules\workflow\packages\body\PKG_WORKFLOW.pkb

PROMPT
PROMPT Workflow Module Installation Completed
PROMPT ==========================================
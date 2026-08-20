/*====================================================================
  APEXONE Enterprise Platform

  File Name    : install_configuration.sql
  Module       : Configuration Framework

  Purpose:
  Installation script for APEXONE Configuration Module.

  Version      : 1.0.0-alpha.3

  Database     : Oracle AI Database 26ai
====================================================================*/

PROMPT ==========================================
PROMPT Installing CONFIGURATION Module
PROMPT ==========================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET SQLBLANKLINES ON

WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT
PROMPT Creating Configuration Tables...
PROMPT ==========================================

@modules\configuration\tables\app_config_groups.sql
@modules\configuration\tables\app_config.sql

PROMPT
PROMPT Applying Configuration Constraints...
PROMPT ==========================================

@modules\configuration\constraints\app_config_groups_pk.sql
@modules\configuration\constraints\app_config_pk.sql
@modules\configuration\constraints\app_config_key_uk.sql
@modules\configuration\constraints\app_config_group_fk.sql

PROMPT
PROMPT Installing Configuration Packages...
PROMPT ==========================================

@modules\configuration\packages\spec\PKG_CONFIGURATION.pks
@modules\configuration\packages\body\PKG_CONFIGURATION.pkb

PROMPT
PROMPT Configuration Module Installation Completed
PROMPT ==========================================
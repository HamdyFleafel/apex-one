/*====================================================================
  APEXONE Enterprise Platform

  File Name    : install_notification.sql
  Module       : Notification Framework

  Purpose:
  Installation script for APEXONE Notification Module.

  Version      : 1.0.0-alpha.4
====================================================================*/

PROMPT ==========================================
PROMPT Installing NOTIFICATION Module
PROMPT ==========================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET SQLBLANKLINES ON

WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT
PROMPT Creating Notification Tables...
PROMPT ==========================================

@modules\notification\tables\app_notification_templates.sql
@modules\notification\tables\app_notifications.sql

PROMPT
PROMPT Applying Notification Constraints...
PROMPT ==========================================

@modules\notification\constraints\app_notification_templates_pk.sql
@modules\notification\constraints\app_notification_templates_code_uk.sql
@modules\notification\constraints\app_notifications_pk.sql
@modules\notification\constraints\app_notifications_template_fk.sql

PROMPT
PROMPT Installing Notification Packages...
PROMPT ==========================================

@modules\notification\packages\spec\PKG_NOTIFICATION.pks
@modules\notification\packages\body\PKG_NOTIFICATION.pkb

PROMPT
PROMPT Notification Module Installation Completed
PROMPT ==========================================
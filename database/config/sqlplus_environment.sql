-- =============================================================================
-- Project      : APEXONE Enterprise Platform
-- Component    : SQL*Plus Environment
-- Object Name  : SQLPLUS_ENVIRONMENT
-- Object Type  : CONFIGURATION
-- File         : sqlplus_environment.sql
-- Schema       : N/A
-- Owner        : Hamdy Fleafel
--
-- Purpose      : Standard SQL*Plus environment settings used by all deployment
--                and database object scripts.
--
-- Created      : 2026-08-02
-- Version      : 0.2.0
--
-- Change Log
-- -----------------------------------------------------------------------------
-- Version   Date         Author            Description
-- --------  ----------   ----------------  -------------------------------
-- 0.2.0     2026-08-02   Hamdy Fleafel     Initial Version
-- =============================================================================

SET DEFINE OFF
SET VERIFY OFF
SET FEEDBACK ON
SET ECHO OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 100

WHENEVER SQLERROR EXIT SQL.SQLCODE

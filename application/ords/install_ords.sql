SET DEFINE OFF
SET SERVEROUTPUT ON

WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT ============================================================
PROMPT Installing APEXONE ORDS modules
PROMPT ============================================================

@modules/create_user.sql

PROMPT ============================================================
PROMPT APEXONE ORDS modules installed successfully
PROMPT ============================================================

EXIT SUCCESS

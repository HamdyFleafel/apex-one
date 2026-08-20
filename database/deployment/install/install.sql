-- APEXONE canonical database installation entry point
-- Architecture v1.0

SET DEFINE OFF
SET SERVEROUTPUT ON

WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

@deployment/lifecycle/install/install_complete.sql

EXIT SUCCESS
-- Compatibility wrapper. Canonical installer: deployment/install/install.sql
SET DEFINE OFF
WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
@deployment/install/install.sql
EXIT SUCCESS

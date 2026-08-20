-- Compatibility wrapper. Canonical seed orchestration is deployment/lifecycle/install.
SET DEFINE OFF
WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
@build/build_seed.sql

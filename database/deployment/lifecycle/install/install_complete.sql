-- APEXONE canonical lifecycle install

SET DEFINE OFF
SET SERVEROUTPUT ON

WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

@deployment/lifecycle/install/install_platform.sql
@deployment/lifecycle/install/install_modules.sql
@deployment/lifecycle/install/install_seed.sql
@build/build_verification.sql
@build/build_healthcheck.sql
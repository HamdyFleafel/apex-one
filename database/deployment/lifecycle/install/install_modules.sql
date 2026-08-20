-- APEXONE canonical lifecycle: module installation owner

SET DEFINE OFF

WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

@modules/core/install_core.sql
@modules/identity/install_identity.sql
@modules/integration/install_integration.sql
@modules/security/install_security.sql
@modules/configuration/install_configuration.sql
@modules/notification/install_notification.sql
@modules/workflow/install_workflow.sql
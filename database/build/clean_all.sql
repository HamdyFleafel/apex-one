-- APEXONE full cleanup entry point.
-- Object-specific uninstall implementations are introduced through the
-- deployment/lifecycle layer. This script intentionally delegates there
-- rather than maintaining a second source of uninstall logic.

@deployment/lifecycle/uninstall/drop_modules.sql
@deployment/lifecycle/uninstall/drop_framework.sql

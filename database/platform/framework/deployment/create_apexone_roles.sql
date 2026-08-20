-- =====================================================
-- APEXONE Platform
-- Database Roles Creation
-- Oracle Database 26ai Free
-- =====================================================

CREATE ROLE APEXONE_APP_ROLE;

GRANT CREATE SESSION
TO APEXONE_APP_ROLE;

-- Additional privileges
-- will be granted by application requirements
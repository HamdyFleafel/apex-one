SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT Installing APEXONE ORDS modules...
@application/ords/modules/create_user.sql
PROMPT APEXONE ORDS modules installed successfully.

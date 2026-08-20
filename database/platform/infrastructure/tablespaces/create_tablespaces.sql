/*====================================================================
  APEXONE Enterprise Platform
  File Name : create_tablespaces.sql
  Purpose   : Idempotent bootstrap/verification of DATA / INDEX / AUDIT.
  Version   : 1.1.0-alpha.1
====================================================================*/

PROMPT ==========================================
PROMPT APEXONE ENTERPRISE TABLESPACE BOOTSTRAP
PROMPT ==========================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

DECLARE
    l_exists NUMBER;
    PROCEDURE ensure_ts(p_name VARCHAR2, p_file VARCHAR2, p_size VARCHAR2, p_next VARCHAR2, p_max VARCHAR2) IS
    BEGIN
        SELECT COUNT(*) INTO l_exists FROM DBA_TABLESPACES WHERE TABLESPACE_NAME = UPPER(p_name);
        IF l_exists = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Creating ' || p_name || '...');
            EXECUTE IMMEDIATE
                'CREATE TABLESPACE ' || p_name ||
                ' DATAFILE ''' || p_file || '''' ||
                ' SIZE ' || p_size ||
                ' AUTOEXTEND ON NEXT ' || p_next ||
                ' MAXSIZE ' || p_max;
            DBMS_OUTPUT.PUT_LINE(p_name || ' created.');
        ELSE
            DBMS_OUTPUT.PUT_LINE(p_name || ' already exists. Skipping creation.');
        END IF;
    END;
BEGIN
    ensure_ts('APEXONE_DATA', 'D:\ORACLE\DB\ORADATA\FREE\APEXONE_DATA01.DBF', '1024M', '64M', '6096M');
    ensure_ts('APEXONE_INDEX', 'D:\ORACLE\DB\ORADATA\FREE\APEXONE_IDX01.DBF', '256M', '64M', '1536M');
    ensure_ts('APEXONE_AUDIT', 'D:\ORACLE\DB\ORADATA\FREE\APEXONE_AUD01.DBF', '256M', '64M', '1536M');
END;
/

SELECT tablespace_name, status, contents
FROM dba_tablespaces
WHERE tablespace_name IN ('APEXONE_DATA','APEXONE_INDEX','APEXONE_AUDIT')
ORDER BY tablespace_name;

PROMPT ==========================================
PROMPT APEXONE TABLESPACE BOOTSTRAP COMPLETED
PROMPT ==========================================
EXIT

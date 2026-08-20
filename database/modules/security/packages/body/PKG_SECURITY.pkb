/*====================================================================
  APEXONE Enterprise Platform

  Object Type : PACKAGE BODY
  Object Name : PKG_SECURITY

  Module      : Security Framework

  Version     : 1.0.0

====================================================================*/


SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF

WHENEVER SQLERROR EXIT SQL.SQLCODE


CREATE OR REPLACE PACKAGE BODY pkg_security
AS


    FUNCTION has_permission
    (
        p_role_id NUMBER,
        p_permission_code VARCHAR2
    )
    RETURN BOOLEAN

    IS

        l_count NUMBER;


    BEGIN


        SELECT COUNT(*)
        INTO l_count

        FROM app_role_permissions rp

        INNER JOIN app_permissions p
            ON p.permission_id = rp.permission_id

        WHERE rp.role_id = p_role_id
          AND p.permission_code = p_permission_code;


        RETURN l_count > 0;


    END has_permission;


END pkg_security;
/
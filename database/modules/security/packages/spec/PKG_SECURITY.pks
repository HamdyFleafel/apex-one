/*====================================================================
  APEXONE Enterprise Platform

  Object Type : PACKAGE SPEC
  Object Name : PKG_SECURITY

  Module      : Security Framework

  Version     : 1.0.0

====================================================================*/

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF

WHENEVER SQLERROR EXIT SQL.SQLCODE


CREATE OR REPLACE PACKAGE pkg_security
AS


    FUNCTION has_permission
    (
        p_role_id NUMBER,
        p_permission_code VARCHAR2
    )
    RETURN BOOLEAN;


END pkg_security;
/